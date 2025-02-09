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
    
    let mbtiCategoryStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    let mbtiCategory1 = MBTIPartView()
    let mbtiCategory2 = MBTIPartView()
    let mbtiCategory3 = MBTIPartView()
    let mbtiCategory4 = MBTIPartView()
    
    lazy var mbtiLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.iaDictionary["mbti.label"]
        label.font = .boldSystemFont(ofSize: 18)
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
        [selectedProfileView, textFieldView, validationLabel, mbtiCategoryStack, mbtiLabel].forEach {
            view.addSubview($0)
        }
        
        [mbtiCategory1, mbtiCategory2, mbtiCategory3, mbtiCategory4].forEach {
            mbtiCategoryStack.addArrangedSubview($0)
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
        
        mbtiCategoryStack.snp.makeConstraints {
            $0.top.equalTo(validationLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-25)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(validationLabel.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        if !isModalPresentation {
            completionButton.snp.makeConstraints {
                $0.top.equalTo(mbtiCategoryStack.snp.bottom).offset(30)
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
        completionButton.isEnabled =  (viewModel.nicknameValidationResult.value?.0 ?? false) && (viewModel.mbtiDoneInfo.value)
        
        mbtiCategory1.setText(mbtiCategory: MBTI1.allCases.map { $0.getName()})
        mbtiCategory2.setText(mbtiCategory: MBTI2.allCases.map { $0.getName()})
        mbtiCategory3.setText(mbtiCategory: MBTI3.allCases.map { $0.getName()})
        mbtiCategory4.setText(mbtiCategory: MBTI4.allCases.map { $0.getName()})
        
        var buttonIndex: Int = 0
        
        [mbtiCategory1, mbtiCategory2, mbtiCategory3, mbtiCategory4].forEach {
            $0.button1.tag = buttonIndex
            $0.button2.tag = buttonIndex + 1
            
            $0.button1.addTarget(self, action: #selector(selectMBTIPart), for: .touchUpInside)
            $0.button2.addTarget(self, action: #selector(selectMBTIPart), for: .touchUpInside)
            
            buttonIndex += 2
        }
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
    
    @objc func selectMBTIPart(_ sender: UIButton) {
        viewModel.mbtiInputRecognizer.value = sender.tag
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

//MARK: - Data Bindings
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
            
            //TODO: 버튼 상태를 표시하는 값이 하나로 통일되어야하는가?
            self?.completionButton.isEnabled = canGoNext && (self?.checkAllMBTIFilled())!
            self?.validationLabel.textColor = labelColor
            self?.validationLabel.text = validationMessage
        }
        
        //TODO: 이걸 빼먹으면, 글자가 들어가지 않는다. + 반복되는 코드를 재사용 가능한 형태로 리팩토링할 필요가 있다.
        viewModel.mbtiOutput1.bind { [weak self] value in
            let chosenPart: Int? = value == .none ? nil : value.getRawInt()
            self?.mbtiCategory1.setChosenPart(locationAt: chosenPart )
            
            //TODO: intput-bind 에서 mbti입력을 확인하면, 호출 사이클이 이곳보다 느려서 제대로 된 검사가 되지 않는다.
//            self?.completionButton.isEnabled = (self?.viewModel.nicknameValidationResult.value?.0 ?? false) && (self?.viewModel.mbtiDoneInfo.value)!
            
            self?.completionButton.isEnabled = (self?.viewModel.nicknameValidationResult.value?.0 ?? false) && (self?.checkAllMBTIFilled())!
            
        }
        
        viewModel.mbtiOutput2.bind { [weak self] value in
            let chosenPart: Int? = value == .none ? nil : value.getRawInt()
            self?.mbtiCategory2.setChosenPart(locationAt: chosenPart )
            self?.completionButton.isEnabled = (self?.viewModel.nicknameValidationResult.value?.0 ?? false) && (self?.checkAllMBTIFilled())!
        }
        
        viewModel.mbtiOutput3.bind { [weak self] value in
            let chosenPart: Int? = value == .none ? nil : value.getRawInt()
            self?.mbtiCategory3.setChosenPart(locationAt: chosenPart )
            self?.completionButton.isEnabled = (self?.viewModel.nicknameValidationResult.value?.0 ?? false) && (self?.checkAllMBTIFilled())!
        }
        
        viewModel.mbtiOutput4.bind { [weak self] value in
            let chosenPart: Int? = value == .none ? nil : value.getRawInt()
            self?.mbtiCategory4.setChosenPart(locationAt: chosenPart )
            self?.completionButton.isEnabled = (self?.viewModel.nicknameValidationResult.value?.0 ?? false) && (self?.checkAllMBTIFilled())!
        }
        
    }
    
    // TODO: 추후에 수정이 필요하다.(viewModel단으로 넘겨야한다)
    func checkAllMBTIFilled() -> Bool {
        let mbti: [Int] = [
            viewModel.mbtiOutput1.value.getRawInt(),
            viewModel.mbtiOutput2.value.getRawInt(),
            viewModel.mbtiOutput3.value.getRawInt(),
            viewModel.mbtiOutput4.value.getRawInt()
        ]
        
        return mbti.allSatisfy { $0 != 2 }
    }
}
