//
//  SettingViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit

class SettingViewController: BaseViewController {
    
    let titleList = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    let mainCard = MainCardView()
    let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    //MARK: View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
    }
    
    override func setInitialValue() {
        navigationName = "설정"
    }
    
    override func configureViewHierarchy() {
        [mainCard, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        mainCard.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainCard.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViewDetails() {
        tableView.backgroundColor = AppColor.mainBackground.inUIColorFormat
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = AppColor.cardBackground.inUIColorFormat
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        mainCard.isUserInteractionEnabled = true
        let tapOnProfileCard = UITapGestureRecognizer(target: self, action: #selector(showProfileSheet))
        mainCard.addGestureRecognizer(tapOnProfileCard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainCard.viewModel.input.refreshRequest.value = ()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCard.layer.cornerRadius = 10
    }
}

//MARK: TableView Protocols
extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as? SettingTableViewCell {
            cell.fillUpData(with: titleList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // show actionable alert only when "탈퇴하기" tapped
        if indexPath.row == titleList.count - 1 {
            showAlert()
        }
    }
}

//MARK: ReverseValueAssigning Protocol
extension SettingViewController: ReverseValueAssigning {
    // for like button pressed from collectionviewcell
    func upstreamAction<T>(with: T) {
        if let _ = with as? Int {
            mainCard.viewModel.input.refreshRequest.value = ()
        }
        
        if let _ = with as? UIColor {
            view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        }
    }
}

//MARK: Actions
extension SettingViewController {
    func showAlert(){
        let alertController = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 모든 데이터가 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
        let withdrawAction = UIAlertAction(title: "확인", style: .destructive) { (_) in
            
            ApplicationUserData.withdraw()
            
            let destinationVC = OnboardViewController()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }
            window.rootViewController = UINavigationController(rootViewController: destinationVC)
            window.makeKeyAndVisible()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(withdrawAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func showProfileSheet() {
        let destinationVC = ProfileViewController(isModalPresentation: true)
        destinationVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true // seems not working in the back background + light appearance
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = AppColor.cardBackground.inUIColorFormat
        }
        
        present(UINavigationController(rootViewController: destinationVC), animated: true)
    }
}
