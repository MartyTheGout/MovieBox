//
//  SelectedProfileView.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

class SelectedProfileView: BaseView {
    
    var userData: Int = ApplicationUserData.profileNumber
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.borderColor = AppColor.tintBlue.inUIColorFormat.cgColor
        imageView.layer.borderWidth = AppLineDesign.selected.rawValue
        
        return imageView
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
        [mainImageView,subImageView].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        mainImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        subImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.bottom.trailing.equalTo(mainImageView)
            $0.bottom.trailing.equalToSuperview()
        }
    }
    
    override func configureViewDetails() {
        let profileNumber = userData == 100 ? Int.random(in: 1...11) : userData
        mainImageView.image = UIImage(named: "profile_\(profileNumber)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainImageView.layer.cornerRadius = mainImageView.frame.height / 2
        subImageView.layer.cornerRadius = subImageView.frame.height / 2
        
    }
}
