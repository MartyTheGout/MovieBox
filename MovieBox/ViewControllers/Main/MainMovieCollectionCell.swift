//
//  MainMovieCollectionCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MainMovieCollectionCell: BaseCollectionViewCell, IncludingLike {
    
    static var id : String {
        String(describing: self)
    }
    
    var movieId : Int?
    
    var delegate : ReverseValueAssigning?

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
    
    override func configureViewHierarchy() {
        [imageView, stackView, overviewLabel].forEach { contentView.addSubview($0) }
        [titleLable, likeButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureViewLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.3)
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
    }
    
    @objc func updateLikeStatus() {
        guard let id = movieId else {
            print("[not-proper assignment] id is not set properly")
            return
        }
        
        if let idLocation = ApplicationUserData.likedIdArray.firstIndex(of: id) {
            ApplicationUserData.likedIdArray.remove(at: idLocation)
        } else {
            ApplicationUserData.likedIdArray.append(id)
        }
        
        delegate?.upstreamAction(with: ApplicationUserData.likedIdArray.count)
        
        showLikeStatus(id: id)
    }
    
    func fillUpData(movie: TrendingMovie) {
        if let backdropPath = movie.backdropPath {
            let imageUrl = Datasource.baseImageURL.rawValue + backdropPath
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url )
        }
        
        titleLable.text = movie.title
        
        movieId = movie.id
        showLikeStatus(id: movie.id)
        
        overviewLabel.text = movie.overview
    }
    
    func showLikeStatus(id: Int) {
        let image = ApplicationUserData.likedIdArray.contains(id) ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
        likeButton.setImage(image, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 10 // TODO: 하단 이미지에만 cornerRaius가 적용된 것처럼 보인다. 
    }
}
