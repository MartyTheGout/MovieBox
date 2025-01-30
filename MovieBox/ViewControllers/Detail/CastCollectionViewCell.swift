//
//  CastCollectionViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class CastCollectionViewCell: BaseCollectionViewCell {
    
    static var id: String {
        String(describing: self)
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let realNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    let charactorNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColor.subBackground.inUIColorFormat
        return label
    }()
    
    override func configureViewHierarchy() {
        [imageView, realNameLabel, charactorNameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        imageView.snp.makeConstraints{
            $0.top.leading.equalTo(contentView).inset(4)
            $0.size.equalTo(50)
            $0.bottom.equalTo(contentView).offset(-4)
        }
        
        realNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView).offset(-8)
        }
        
        charactorNameLabel.snp.makeConstraints {
            $0.top.equalTo(realNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView).offset(-8)
        }
    }
    
    func fillUpData(with cast : Cast) {
        let imageURL = URL(string: Datasource.baseImageURL.rawValue + (cast.profilePath ?? ""))
        imageView.kf.setImage(with: imageURL)
        
        realNameLabel.text = cast.name
        charactorNameLabel.text = cast.character
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2 
    }
}
