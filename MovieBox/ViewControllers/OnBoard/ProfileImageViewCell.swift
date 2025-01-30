//
//  ProfileImageViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

final class ProfileImageViewCell: BaseCollectionViewCell {
    
    static var id : String {
        String(describing: self)
    }

    var isChosen = false {
        didSet {
            if isChosen {
                getBlueBoldBorder(view: button)
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
        getBlueBoldBorder(view: button)
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
