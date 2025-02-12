//
//  MainMovieCollectionCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class MainMovieCollectionCell: BaseCollectionViewCell {
    
    static var id : String {
        String(describing: self)
    }
    
    let viewModel = MainCollectionCellViewModel()
    let likeButtonViewModel = LikeButtonViewModel()

    var delegate: ReverseValueAssigning?
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    var likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(AppSFSymbol.whiteHeart.image, for: .normal)
        button.tintColor = AppColor.tintBlue.inUIColorFormat
        return button
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataBindings()
    }
    
    override func configureViewHierarchy() {
        [imageView, stackView, overviewLabel].forEach { contentView.addSubview($0) }
        [titleLable, likeButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureViewLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        overviewLabel.snp.makeConstraints{
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(contentView)
        }
    }
    
    override func configureViewDetails() {
        contentView.backgroundColor = AppColor.mainBackground.inUIColorFormat
        likeButton.addTarget(self, action: #selector(updateLikeStatus), for: .touchUpInside)
        
        self.isSkeletonable = true
        imageView.isSkeletonable = true
        titleLable.isSkeletonable = true
        overviewLabel.isSkeletonable = true
        
        titleLable.linesCornerRadius = 5
        overviewLabel.linesCornerRadius = 5
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        imageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: AppColor.subBackground.inUIColorFormat), animation: animation, transition: .crossDissolve(1))
        
    }
    
    @objc func updateLikeStatus() {
        likeButtonViewModel.input.likeUpdate.value = ()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 10
    }
}

//MARK: - Data Bindings
extension MainMovieCollectionCell {
    func setDataBindings() {
        viewModel.output.movie.bind { [weak self]  movie in
            guard let movie else { return }
            
            if let backdropPath = movie.backdropPath {
                let imageUrl = Datasource.baseImageURL.rawValue + backdropPath
                let url = URL(string: imageUrl)
                self?.imageView.kf.setImage(with: url ) { _ in
                    self?.imageView.stopSkeletonAnimation()
                    self?.imageView.hideSkeleton()
                    self?.imageView.layer.cornerRadius = 10
                }
            }
            
            self?.titleLable.text = movie.title
            self?.overviewLabel.text = movie.overview
        }
        
        likeButtonViewModel.output.likeStatus.bind { [weak self]  isLiked in
            let image = isLiked ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
            self?.likeButton.setImage(image, for: .normal)
            self?.delegate?.upstreamAction(with: isLiked)
        }
    }
}
