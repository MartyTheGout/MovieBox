//
//  ProfileViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    var userData: Int = {
        let userData = ApplicationUserData.profileNumber
        return userData == 100 ? Int.random(in: 0...11) : userData
    }() {
        didSet {
            selectedProfileView.changeImage(userData: self.userData)
        }
    }
    
    lazy var selectedProfileView = SelectedProfileView(userData: self.userData)
    
    let textFieldView = NameTextFieldView()
    let validationLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.tintBlue.inUIColorFormat
        return label
    }()
    
    let completionButton = BlueBorderButton(title: "완료")
    
    var validation = false {
        didSet {
            completionButton.isEnabled = validation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.textField.delegate = self
        textFieldView.textField.becomeFirstResponder() // 굉장히 oop스럽다. 은닉화는 아니지만, getonly 프로퍼티이며, 인스턴스 메소드를 통해서 값을 변경한다.
    }
        
    override func setInitialValue() {
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
            $0.top.equalTo(textFieldView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        completionButton.snp.makeConstraints {
            $0.top.equalTo(validationLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    override func configureViewDetails() {
        textFieldView.textField.text = ApplicationUserData.nickname
        
        completionButton.addTarget(self, action: #selector(registerNickname), for: .touchUpInside)
        selectedProfileView.button.addTarget(self, action: #selector(navigateToImageSelection), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        completionButton.layer.cornerRadius = completionButton.frame.height / 2
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        guard let input = textField.text else { return }
        
        if input.contains(/[@|#|$|%]/) {
            validationLabel.text = "닉네임는 @, #, $, %는 포  함할 수 없어요"
            validation = false
            return
        }
        
        if input.contains(/\d/) {
            validationLabel.text = "닉네임에 숫자는 포함할 수 없어요."
            validation = false
            return
        }
        
        if input.count >= 2 && input.count < 10 {
            validationLabel.text = "사용할 수 있는 닉네임이에요."
            validation = true
            return
        } else {
            validationLabel.text = "닉2글자 이상 10글자 미만으로 설정해주세요."
            validation = false
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldView.textField.resignFirstResponder()
        return true
    }
    
    private func showValidation(message: String) {
        validationLabel.text = message
    }
}

extension ProfileViewController {
    
    @objc func registerNickname() {
        guard let nickname = textFieldView.textField.text else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = userData
        ApplicationUserData.firstLauchState.toggle()
     
        // for the case of re-join the app
        if ApplicationUserData.withdrawalState {
            ApplicationUserData.withdrawalState = false
        }
        
        let destinationVC = MainTabBarController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = destinationVC
        window.makeKeyAndVisible()        
    }
    
    @objc func navigateToImageSelection() {
        let destinationVC = ImageSettingViewController(userData: userData, delegate: self)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ProfileViewController : ReverseValueAssigning {
    func upstreamAction<T>(with: T) {
        if let value = with as? Int {
            self.userData = value
        }
    }
}
