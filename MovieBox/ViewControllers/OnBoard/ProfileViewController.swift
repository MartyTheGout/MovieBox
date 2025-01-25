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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.textField.delegate = self
    }
    
    override func setInitialValue() {
        navigationName = "프로필 설정"
    }
    
    override func configureViewHierarchy() {
        [selectedProfileView, textFieldView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        selectedProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(selectedProfileView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ProfileViewController: UITextFieldDelegate {}
