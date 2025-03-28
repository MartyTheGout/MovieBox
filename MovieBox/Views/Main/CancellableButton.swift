//
//  CancellableButton.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit

class CancellableButton: BaseView {
    
    var keyword: String
    var buttonAction: (() -> Void)
    var cancelAction: (() -> Void)
    
    init(keyword: String, buttonAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        self.keyword = keyword
        self.buttonAction = buttonAction
        self.cancelAction = cancelAction
        super.init(frame: .zero)
    }
    
    lazy var navigateButton : UIButton = {
       let button = UIButton()
        
        let attributedText = NSAttributedString(
            string: keyword,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor : AppColor.mainBackground.inUIColorFormat
            ]
        )
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = AppColor.subInfoDeliver.inUIColorFormat
        return button
    }()
    
    let deleteButton : UIButton = {
       let button = UIButton()
        button.setImage(AppSFSymbol.x.image, for: .normal)
        button.tintColor = AppColor.mainBackground.inUIColorFormat
        button.backgroundColor = AppColor.subInfoDeliver.inUIColorFormat
        return button
    }()
    
    override func configureViewHierarchy() {
        [navigateButton, deleteButton].forEach { addSubview($0)}
    }
    
    override func configureViewLayout() {
        navigateButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(2)
        }
        
        deleteButton.snp.makeConstraints{
            $0.leading.equalTo(navigateButton.snp.trailing).offset(8)
            $0.centerY.equalTo(navigateButton)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func configureViewDetails() {
        backgroundColor = AppColor.subInfoDeliver.inUIColorFormat
        navigateButton.addTarget(self, action: #selector(executeNavigation), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(executeCancellation), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

extension CancellableButton {
    @objc func executeNavigation() {
        buttonAction()
    }
    
    @objc func executeCancellation(){
        cancelAction()
        self.removeFromSuperview()
    }
}
