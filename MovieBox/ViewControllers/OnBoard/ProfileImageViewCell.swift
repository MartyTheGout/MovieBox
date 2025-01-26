//
//  ProfileImageViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

class ProfileImageViewCell: BaseCollectionViewCell {
    
    static var id : String {
        String(describing: self)
    }
    
    var locationAt: Int?
    
    var isChosen = false {
        didSet {
            if isChosen {
                button.layer.borderWidth = AppLineDesign.selected.rawValue
                button.layer.borderColor = AppColor.tintBlue.inUIColorFormat.cgColor
                button.alpha = 1
            } else {
                button.layer.borderWidth = AppLineDesign.unselected.rawValue
                button.layer.borderColor = AppColor.subBackground.inUIColorFormat.cgColor
                button.alpha = 0.5
            }
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = AppLineDesign.selected.rawValue
        button.layer.borderColor = AppColor.tintBlue.inUIColorFormat.cgColor
        button.layer.masksToBounds = true
        return button
    }()
    
    override func configureViewHierarchy() {
        contentView.addSubview(button)
    }
    
    override func configureViewLayout() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    func setCellImage(locationAt: Int) {
        button.setImage(UIImage(named: "profile_\(locationAt)"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}
