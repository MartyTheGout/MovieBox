//
//  SearchTableViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: BaseTableViewCell {
    
    static var id : String { String (describing: self) }
    
    var searcheMovie: TrendingMovie?
    
    let mainImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = AppColor.subBackground.inUIColorFormat
        return label
    }()
    
    let genreStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    let likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(AppSFSymbol.whiteHeart.image, for: .normal)
        button.tintColor = AppColor.tintBlue.inUIColorFormat
        return button
    }()
    
    let genreLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = AppColor.cardBackground.inUIColorFormat
        return label
    }()
    
    override func configureViewHierarchy() {
        [mainImage, titleLabel, dateLabel, genreStack, likeButton].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        mainImage.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(16)
            let width: CGFloat = UIScreen.main.bounds.width / 4
            $0.width.equalTo(width)
            $0.height.equalTo(width).multipliedBy(1.2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
        }
        
        genreStack.snp.makeConstraints {
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
            $0.bottom.equalTo(contentView).offset(-16)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-16)
            $0.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    override func configureViewDetails() {
        contentView.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    func fillUpData(with data: SearchedMovie) {
        mainImage.kf.setImage(with: URL(string: Datasource.baseImageURL.rawValue + data.posterPath)!)
        
        titleLabel.text = data.title
        dateLabel.text = data.releaseDate
        
        data.genreIDS.forEach { (id) in
            let genreInKorean = Genre(rawValue: id)?.koreanName
            
            let label = {
                let label = UILabel()
                label.text = genreInKorean
                label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
                label.font = UIFont.systemFont(ofSize: 13)
                label.backgroundColor = AppColor.cardBackground.inUIColorFormat
                label.layer.cornerRadius = label.frame.height / 2
                return label
            }()
            
            genreStack.addArrangedSubview(label)
        }
    }
    
}
