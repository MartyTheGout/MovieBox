//
//  CastCollectionViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit

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
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    let charactorNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        return label
    }()
    
    override func configureViewHierarchy() {
        
    }
    
    override func configureViewLayout() {
        
    }
}
