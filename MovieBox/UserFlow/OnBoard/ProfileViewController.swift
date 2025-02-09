//
//  ProfileViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    let viewModel = ProfileViewModel()
    
    var isModalPresentation: Bool
    
    var delegate : ReverseValueAssigning?
    
    init (isModalPresentation: Bool = false) {
        self.isModalPresentation = isModalPresentation
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Components
    lazy var selectedProfileView = SelectedProfileView(userData: self.viewModel.userProfileNumber.value)
    
    let textFieldView = NameTextFieldView()
    let validationLabel : UILabel = {
        let label = UILabel()
        label.textColor = AppColor.tintBlue.inUIColorFormat
        return label
    }()
    
    lazy var completionButton = ColorFilledButton(title: viewModel.iaDictionary["button.text"] ?? "")
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldView.textField.delegate = self
        textFieldView.textField.becomeFirstResponder()
        setDataBindings()
    }
    
    override func setInitialValue() {
        if let _ = presentingViewController {
            navigationName = viewModel.iaDictionary["modal.title"]
        } else {
            navigationName = viewModel.iaDictionary["nav.push.title"]
        }
    }
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : AppColor.mainBackground.inUIColorFormat
        ]
        
        if let title = navigationName {
            navigationItem.title = title
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
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
        view.backgroundColor = .white
        
        textFieldView.textField.text = ApplicationUserData.nickname
        
        completionButton.addTarget(self, action: #selector(registerNickname), for: .touchUpInside)
        selectedProfileView.button.addTarget(self, action: #selector(navigateToImageSelection), for: .touchUpInside)
        
        //If there is no input entered, initially button should be dis-enabled
        completionButton.isEnabled = viewModel.nicknameValidationResult.value?.0 ?? false
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
        viewModel.nicknameInput.value = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldView.textField.resignFirstResponder()
        return true
    }
}

//MARK: Actions
extension ProfileViewController {
    @objc func registerNickname() {
        // ViewModel's part
        viewModel.registerButtonRecognizer.value = ()
        
        // ViewController's part
        let destinationVC = MainTabBarController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
        window.rootViewController = destinationVC
        window.makeKeyAndVisible()
    }
    
    @objc func navigateToImageSelection() {
        let destinationVC = ImageSettingViewController(userData: viewModel.userProfileNumber.value, delegate: self)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func goBackToThePreviousView(){
        dismiss(animated: true)
    }
    
    @objc func modifyProfileInfo() {
        viewModel.modifyButtonRecognizer.value = ()
        
        //Update MainViewController's mainCard's Data
        delegate?.upstreamAction(with: viewModel.userProfileNumber.value)
        
        dismiss(animated: true)
    }
}

//MARK: - ReverseValueAssigning
extension ProfileViewController : ReverseValueAssigning {
    func upstreamAction<T>(with: T) {
        if let value = with as? Int {
            self.viewModel.userProfileNumber.value = value
        }
    }
}

//MARK: - DataBinding
extension ProfileViewController {
    func setDataBindings() {
        viewModel.userProfileNumber.bind { [weak self] number  in
            if number == 100 {
                self?.viewModel.userProfileNumber.value = Int.random(in: 0...11)
            } else {
                self?.selectedProfileView.changeImage(userData: number)
            }
        }
        
        viewModel.nicknameValidationResult.bind { [weak self] result in
            guard let (canGoNext, validationMessage, labelColor) = result else {
                return
            }
            
            self?.completionButton.isEnabled = canGoNext
            self?.validationLabel.textColor = labelColor
            self?.validationLabel.text = validationMessage
        }
    }
}
