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
    
    override func configureViewHierarchy() {
        [mainImage, titleLabel, dateLabel, genreStack, likeButton].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        mainImage.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(16)
            let width: CGFloat = UIScreen.main.bounds.width / 5
            $0.width.equalTo(width)
            $0.height.equalTo(mainImage.snp.width).multipliedBy(1.1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
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
        
        // genreStack의 서브뷰 초기화
        genreStack.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let availableGenre = 2
        
        for (index, genre) in data.genreIDS.enumerated() {
            
            // Application Spec: 검색페이지에서 열람가능한 장르 정보는 2개까지이다.
            if index >= availableGenre { return }
            
            let genreInKorean = Genre(rawValue: genre)?.koreanName
            
            let genreView = GenreInfoView()
            genreView.backgroundColor = AppColor.cardBackground.inUIColorFormat
            genreView.fillupData(text: genreInKorean!)
            
            genreStack.addArrangedSubview(genreView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10
    }
}
