//
//  MainCardView.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

class MainCardView: BaseView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_\(ApplicationUserData.profileNumber)")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        getBlueBoldBorder(view: imageView) // TODO: check , check value capture
        return imageView
    }()
    
    let verticalStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.text = "\(ApplicationUserData.nickname)"
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = AppColor.subBackground.inUIColorFormat
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.text = "\(ApplicationUserData.registrationDate)"
        return label
    }()
    
    let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppSFSymbol.chevronRight.image
        imageView.tintColor = AppColor.subBackground.inUIColorFormat
        return imageView
    }()
    
    let likeInfoButton: UIButton = {
        let button = UIButton()
        
        let attributedString = NSAttributedString(
            string: "\(ApplicationUserData.likedIdArray.count)개의 무비박스 보관 중",
            attributes: [
                .foregroundColor: AppColor.mainInfoDeliver.inUIColorFormat,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ])
    
//        var colorinfo =AppColor.tintBlue.inUIColorFormat
//        colorinfo.withAlphaComponent(0.5)
        button.backgroundColor = AppColor.tintBlue.inUIColorFormat.withAlphaComponent(0.5)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    override func configureViewHierarchy() {
        [imageView, verticalStack, chevron, likeInfoButton].forEach { addSubview($0) }
        [nicknameLabel, dateLabel].forEach { verticalStack.addArrangedSubview($0)}
    }
    
    override func configureViewLayout() {
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.size.equalTo(50)
        }
        
        verticalStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        chevron.snp.makeConstraints {
            $0.centerY.equalTo(verticalStack)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        likeInfoButton.snp.makeConstraints {
            $0.leading.equalTo(imageView)
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
    }
    
    override func configureViewDetails() {
        backgroundColor = AppColor.cardBackground.inUIColorFormat
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        likeInfoButton.layer.cornerRadius = 10
    }
}
