//
//  MainCardView.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

class MainCardView: BaseView {
    
    var profileImageAsset = ApplicationUserData.profileNumber
    
    //MARK: View Components
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_\(profileImageAsset)")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.mainBackground.inUIColorFormat
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
    
    var nickname = ApplicationUserData.nickname
    lazy var  nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.text = nickname
        return label
    }()
    
    var date = ApplicationUserData.registrationDate
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.subBackground.inUIColorFormat
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppSFSymbol.chevronRight.image
        imageView.tintColor = AppColor.subBackground.inUIColorFormat
        return imageView
    }()
    
    var likeCount = ApplicationUserData.likedIdArray.count
    lazy var likeInfoButton: UIButton = {
        let button = UIButton()
        
        let attributedString = NSAttributedString(
            string: "\(likeCount)개의 무비박스 보관 중",
            attributes: [
                .foregroundColor: AppColor.mainInfoDeliver.inUIColorFormat,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ])
    
        button.backgroundColor = AppColor.tintBlue.inUIColorFormat.withAlphaComponent(0.5)
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    //MARK: View Controller Life Cycle
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
        dateLabel.text = convertDateToFormattedData(date: date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        likeInfoButton.layer.cornerRadius = 10
    }
}

//MARK: Actions
extension MainCardView {
    func refreshViewData() {
        if nickname != ApplicationUserData.nickname {
            nickname = ApplicationUserData.nickname
            nicknameLabel.text = nickname
        }
        
        if date != ApplicationUserData.registrationDate {
            date = ApplicationUserData.registrationDate
            dateLabel.text = convertDateToFormattedData(date: date)
        }
        
        if likeCount != ApplicationUserData.likedIdArray.count {
            likeCount = ApplicationUserData.likedIdArray.count
            
            let attributedString = NSAttributedString(
                string: "\(likeCount)개의 무비박스 보관 중",
                attributes: [
                    .foregroundColor: AppColor.mainInfoDeliver.inUIColorFormat,
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold)
                ])
            likeInfoButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        if profileImageAsset != ApplicationUserData.profileNumber {
            profileImageAsset = ApplicationUserData.profileNumber
            imageView.image = UIImage(named: "profile_\(profileImageAsset)")
        }
    }
    
    private func convertDateToFormattedData (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd 가입"
        
        return dateFormatter.string(from: date)
    }
}
