//
//  MainViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

class MainViewController: BaseViewController {

//    let recentlyUsedKeyword = ApplicationUserData.recentlyUsedKeyword
    let recentlyUsedKeyword = ["마블 엔드게임","더 지니어스","권상우가 나오는","왕좌의 게임","스릴러","공포","감동이 밀려드는"]
    
    let mainCard = MainCardView()
    
    let searchHeaderView: UIStackView = {
      let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let seatchTitleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "최근 검색어"
        return label
    }()
    
    let keywordDeleteButton : UIButton = {
        let button = UIButton()
        
        let attributedString = NSAttributedString(
            string: "전체 삭제",
            attributes: [
                .foregroundColor : AppColor.tintBlue.inUIColorFormat,
                    .font : UIFont.systemFont(ofSize: 13, weight: .bold)
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    let noresultLabel : UILabel = {
        let label = UILabel()
        label.text = "최근 검색어 내역이 없습니다."
        label.textColor = AppColor.cardBackground.inUIColorFormat
        label.font = .systemFont(ofSize: 11, weight: .bold)
        return label
    }()
    
    let buttonScrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bouncesZoom = true
        return scrollView
    }()
    
//    let buttonContainer = UIView()
    let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setInitialValue() {
        navigationName = "Movie Box"
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppSFSymbol.magnifyingglass.image, style: .plain, target: self, action: #selector(navigateToSearchPage))
    }
    
    override func configureViewHierarchy() {
        
        [mainCard, searchHeaderView, buttonScrollView].forEach { view.addSubview($0) }
        [seatchTitleLable,keywordDeleteButton ].forEach { searchHeaderView.addArrangedSubview($0) }
        buttonScrollView.addSubview(buttonContainer)
        
        recentlyUsedKeyword.forEach { value in
            let button : UIButton = {
                let button = UIButton()
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = AppColor.subBackground.inUIColorFormat
                button.setTitle(value, for: .normal)
                return button
            }()
            
            buttonContainer.addArrangedSubview(button)
        }
    }
    
    override func configureViewLayout() {
        mainCard.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        searchHeaderView.snp.makeConstraints{
            $0.top.equalTo(mainCard.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        buttonScrollView.snp.makeConstraints{
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
//            $0.height = 100
        }
        
        buttonContainer.snp.makeConstraints {
            $0.height.equalTo(buttonScrollView.snp.height)
            $0.horizontalEdges.equalTo(buttonScrollView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainCard.layer.cornerRadius = 10
    }
}

extension MainViewController {
    @objc func navigateToSearchPage() {
        print(#function)
    }
}
