//
//  SelectedProfileView.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

class SelectedProfileView: BaseView {
    
    var userData: Int = ApplicationUserData.profileNumber
    var isClickable: Bool = true
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = AppLineDesign.selected.rawValue
        button.layer.borderColor = AppColor.tintBlue.inUIColorFormat.cgColor
        button.layer.masksToBounds = true
        button.isEnabled = self.isClickable
        
        return button
    }()
    
    let subImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppSFSymbol.camera.image
        imageView.backgroundColor = AppColor.tintBlue.inUIColorFormat
        imageView.tintColor = AppColor.mainInfoDeliver.inUIColorFormat
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func configureViewHierarchy() {
        [button,subImageView].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        button.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(button.snp.width)
        }
        
        subImageView.snp.makeConstraints {
            $0.size.equalTo(button.snp.size).dividedBy(3)
            $0.bottom.trailing.equalTo(button)
        }
    }
    
    override func configureViewDetails() {
        let profileNumber = userData == 100 ? Int.random(in: 1...11) : userData
        button.setImage(UIImage(named: "profile_\(profileNumber)"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
        subImageView.layer.cornerRadius = subImageView.frame.height / 2
    }
}
