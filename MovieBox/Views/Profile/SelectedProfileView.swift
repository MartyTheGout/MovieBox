//
//  SelectedProfileView.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

class SelectedProfileView: BaseView {
    
    var userData: Int
    var isClickable: Bool = true
    
    init(userData: Int) {
        self.userData = userData
        super.init(frame: .zero)
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        
        button.layer.masksToBounds = true
        button.isEnabled = self.isClickable
        button.layer.borderColor = AppColor.woodenConcept2.inUIColorFormat.cgColor
        button.layer.borderWidth = 3
        
        return button
    }()
    
    let subImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppSFSymbol.camera.image
        imageView.backgroundColor = AppColor.woodenConcept2.inUIColorFormat
        imageView.tintColor = .white
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func configureViewHierarchy() {
        [button,subImageView].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        subImageView.snp.makeConstraints {
            $0.size.equalTo(button.snp.size).dividedBy(3)
            $0.bottom.trailing.equalTo(button)
        }
    }
    
    override func configureViewDetails() {
        button.imageView?.contentMode = .scaleAspectFill
        changeImage(userData: userData)
    }
    
    func changeImage(userData: Int) {
        button.setImage(UIImage(named: "profile_\(userData)"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
        subImageView.layer.cornerRadius = subImageView.frame.height / 2
    }
}
