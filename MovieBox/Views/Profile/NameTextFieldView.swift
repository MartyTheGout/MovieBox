//
//  SelectedProfileView.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

class NameTextFieldView: BaseView {
    
    var userData: String = ApplicationUserData.nickname
    
    let textField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = AppColor.mainBackground.inUIColorFormat
        textField.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        textField.tintColor = AppColor.mainInfoDeliver.inUIColorFormat
        
        return textField
    }()
    
    let underLine: UIView = {
        let underLine = UIView()
        underLine.layer.borderColor = AppColor.subInfoDeliver.inUIColorFormat.cgColor
        underLine.layer.borderWidth = 2
        return underLine
    }()
    
    override func configureViewHierarchy() {
        [textField,underLine].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        underLine.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(1)
            $0.bottom.trailing.equalToSuperview()
        }
    }
}
