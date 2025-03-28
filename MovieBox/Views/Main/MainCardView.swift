//
//  MainCardView.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

class MainCardView: BaseView {
    
    let viewModel = MainCardViewModel()
    
    //MARK: View Components
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.mainBackground.inUIColorFormat
        imageView.clipsToBounds = true
        imageView.layer.borderColor = AppColor.woodenConcept2.inUIColorFormat.cgColor
        imageView.layer.borderWidth = 2
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
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.text = nickname
        return label
    }()
    
    var date = ApplicationUserData.registrationDate
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let chevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AppSFSymbol.chevronRight.image
        imageView.tintColor = AppColor.subInfoDeliver.inUIColorFormat
        return imageView
    }()
    
    var likeCount = ApplicationUserData.likedIdArray.count
    lazy var likeInfoButton: UIButton = {
        let button = UIButton()

        let textString = NSAttributedString(
            string: "\(likeCount)개를 무비서랍에 보관 중",
            attributes: [
                .foregroundColor: AppColor.mainInfoDeliver.inUIColorFormat,
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ]
        )
        button.setImage(UIImage(systemName: "tray.2.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
                        , for: .normal)

        button.setAttributedTitle(textString, for: .normal)
        button.backgroundColor = AppColor.woodenConcept2.inUIColorFormat.withAlphaComponent(0.5)
        button.layer.borderWidth = 3.0
        button.layer.borderColor = AppColor.woodenConcept2.inUIColorFormat.cgColor
        button.layer.cornerRadius = 8
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)

        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        return button
    }()

    
    //MARK: View Controller Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataBindings()
    }
    
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
        backgroundColor = AppColor.subBackground.inUIColorFormat
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        likeInfoButton.layer.cornerRadius = 10
    }
}

//MARK: Data Bindings
extension MainCardView {
    func setDataBindings() {
        viewModel.output.profileImageAsset.bind{ [weak self] value in
            self?.imageView.image = UIImage(named: "profile_\(value)")
        }
        
        viewModel.output.likeCount.bind{ [weak self] value in
            let attributedString = NSAttributedString(
                string: "\(value)개의 무비박스 보관 중",
                attributes: [
                    .foregroundColor: AppColor.mainInfoDeliver.inUIColorFormat,
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold)
                ])
            self?.likeInfoButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        viewModel.output.date.bind{ [weak self] value in
            let date = self?.viewModel.convertDateToFormattedData(date: value)
            self?.dateLabel.text = date
        }
        
        viewModel.output.nickname.bind{ [weak self] value in
            self?.nicknameLabel.text = value
        }
    }
}
