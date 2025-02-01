//
//  ProfileViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    var isModalPresentation: Bool
    
    var delegate : ReverseValueAssigning?
    
    init (isModalPresentation: Bool = false) {
        self.isModalPresentation = isModalPresentation
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userData: Int = {
        let userData = ApplicationUserData.profileNumber
        return userData == 100 ? Int.random(in: 0...11) : userData
    }() {
        didSet {
            selectedProfileView.changeImage(userData: self.userData)
        }
    }
    
    //MARK: View Components
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
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.textField.delegate = self
        textFieldView.textField.becomeFirstResponder()
    }
        
    override func setInitialValue() {
        if let _ = presentingViewController {
            navigationName = "프로필 편집"
        } else {
            navigationName = "프로필 설정"
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        if isModalPresentation {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: AppSFSymbol.x.image, style: .plain, target: self, action: #selector(goBackToThePreviousView))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(modifyProfileInfo))
            
        }
    }
    
    override func configureViewHierarchy() {
        [selectedProfileView, textFieldView, validationLabel].forEach {
            view.addSubview($0)
        }
        
        if !isModalPresentation {
            view.addSubview(completionButton)
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
        
        if !isModalPresentation {
            completionButton.snp.makeConstraints {
                $0.top.equalTo(validationLabel.snp.bottom).offset(30)
                $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            }
        }
    }
    
    override func configureViewDetails() {
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        textFieldView.textField.text = ApplicationUserData.nickname
        
        completionButton.addTarget(self, action: #selector(registerNickname), for: .touchUpInside)
        selectedProfileView.button.addTarget(self, action: #selector(navigateToImageSelection), for: .touchUpInside)
        
        //If there is no input entered, initially button should be dis-enabled
        completionButton.isEnabled = validation
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        completionButton.layer.cornerRadius = completionButton.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //For converting back to normal view-background-color
        delegate?.upstreamAction(with: AppColor.mainBackground.inUIColorFormat)
    }
}

//MARK: TextField Protocol
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        guard let input = textField.text else { return }
        
        if input.contains(/[@|#|$|%]/) {
            validationLabel.text = "닉네임는 @, #, $, % 는 포함할 수 없어요"
            validationLabel.textColor = .red
            validation = false
            return
        }
        
        if input.contains(/\d/) {
            validationLabel.text = "닉네임에 숫자는 포함할 수 없어요."
            validationLabel.textColor = .red
            validation = false
            return
        }
        
        if input.count >= 2 && input.count < 10 {
            validationLabel.text = "사용할 수 있는 닉네임이에요."
            validationLabel.textColor = AppColor.tintBlue.inUIColorFormat
            validation = true
            return
        } else {
            validationLabel.text = "2글자 이상 10글자 미만으로 설정해주세요."
            validationLabel.textColor = .red
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

//MARK: Actions
extension ProfileViewController {
    @objc func registerNickname() {
        guard let nickname = textFieldView.textField.text else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = userData
        ApplicationUserData.registrationDate = Date()
        ApplicationUserData.firstLauchState = false
     
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
    
    @objc func goBackToThePreviousView(){
        dismiss(animated: true)
    }
    
    @objc func modifyProfileInfo() {
        guard let nickname = textFieldView.textField.text else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = userData
        
        //Update MainViewController's mainCard's Data
        delegate?.upstreamAction(with: userData)
        
        dismiss(animated: true)
    }
}

extension ProfileViewController : ReverseValueAssigning {
    func upstreamAction<T>(with: T) {
        if let value = with as? Int {
            self.userData = value
        }
    }
}
