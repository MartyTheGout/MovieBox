//
//  ProfileViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let selectedProfileView = SelectedProfileView()
    let textFieldView = NameTextFieldView()
    let validationLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.tintBlue.inUIColorFormat
        return label
    }()
    
    let completionButton = BlueBorderButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.textField.delegate = self
    }
        
    override func setInitialValue() {
        print(#function, "ProfileViewController")
        navigationName = "프로필 설정"
    }
    
    override func configureViewHierarchy() {
        [selectedProfileView, textFieldView, validationLabel, completionButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        
        selectedProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(120)
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(selectedProfileView.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        validationLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        completionButton.snp.makeConstraints {
            $0.top.equalTo(validationLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        completionButton.layer.cornerRadius = completionButton.frame.height / 2
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    override func didChangeValue(forKey key: String) {
        print(#function)
        for element in ["@", "#", "$", "%"] {
            if key.contains(element) {
                validationLabel.text = "닉네임는 @, #, $, %는 포함할 수 없어요"
                return
            }
        }
        
        if key.contains(/\d/) {
            validationLabel.text = "닉네임에 숫자는 포함할 수 없어요."
            return
        }
        
        if key.count >= 2 && key.count < 10 {
            validationLabel.text = "사용할 수 있는 닉네임이에요."
            return
        } else {
            validationLabel.text = "닉2글자 이상 10글자 미만으로 설정해주세요."
            return
        }
    }
    
    private func showValidation(message: String) {
        validationLabel.text = message
    }
}
