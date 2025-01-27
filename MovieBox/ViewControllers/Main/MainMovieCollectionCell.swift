//
//  MainMovieCollectionCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MainMovieCollectionCell: BaseCollectionViewCell {
    
    static var id : String {
        String(describing: self)
    }

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
    
    let likeButton : UIButton = {
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
            $0.top.equalTo(stackView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView)
        }
    }
    
    override func configureViewDetails() {
        contentView.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    func fillUpData(movie: Movie) {
        let imageUrl = Datasource.baseImageURL.rawValue + movie.backdropPath
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url )
        
        titleLable.text = movie.title
        
        let image = ApplicationUserData.likedIdArray.contains(movie.id) ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
        likeButton.setImage(image, for: .normal)
        
        overviewLabel.text = movie.overview
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 10
        
    }
}
