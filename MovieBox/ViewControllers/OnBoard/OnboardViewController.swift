//
//  OnboardViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit
import SnapKit

class OnboardViewController: BaseViewController {

    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLable : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "", size: 35)
        label.font = UIFont.systemFont(ofSize: 35, weight: .black)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "Onboarding"
        return label
    }()
    
    let subTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize:17)
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "당신만의 영화 세상,\n MovieBox를 시작해보세요."
        return label
    }()
    
    let button : UIButton = BlueBorderButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.addTarget(self, action: #selector(navigateToMainView), for: .touchUpInside)
    }
    
    override func configureViewHierarchy() {
        [imageView, titleLable, subTitleLabel, button].forEach { view.addSubview($0)}
    }
    
    override func configureViewLayout() {
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        var vertialCoordinateBase = imageView.snp.bottom
        
        titleLable.snp.makeConstraints {
            $0.top.equalTo(vertialCoordinateBase)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        vertialCoordinateBase = titleLable.snp.bottom
        
        subTitleLabel.snp.makeConstraints{
            $0.top.equalTo(vertialCoordinateBase).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        vertialCoordinateBase = subTitleLabel.snp.bottom
        
        button.snp.makeConstraints {
            $0.top.equalTo(vertialCoordinateBase).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(45)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}

//MARK: SubView's action
extension OnboardViewController {
    //TODO: slight lack in the middle of view transition animation
    @objc func navigateToMainView() {
        let destinationVC = ProfileViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
