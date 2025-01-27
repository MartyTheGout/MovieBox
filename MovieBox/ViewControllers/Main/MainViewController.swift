//
//  MainViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

class MainViewController: BaseViewController {

//    let recentlyUsedKeyword = ApplicationUserData.recentlyUsedKeyword
    var recentlyUsedKeyword = ["마블 엔드게임","더 지니어스","권상우가 나오는","왕좌의 게임","스릴러","공포","감동이 밀려드는"]
    
    let mainCard = MainCardView()
    
    lazy var todayMovieList: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let searchHeaderView: UIStackView = {
      let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let searchTitleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
                    .font : UIFont.systemFont(ofSize: 15, weight: .bold)
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
    
    let buttonContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        
        return stackView
    }()
    
    let secondTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "오늘의 영화"
        return label
    }()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        
        let itemWidth : CGFloat = UIScreen.main.bounds.width * 0.55
        let itemHeight : CGFloat = itemWidth * 2
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainMovieCollectionCell.self, forCellWithReuseIdentifier: MainMovieCollectionCell.id)
        
        NetworkManager.shared.callRequest( apiKind: .trending ) { (response : TrendingMovie) -> Void in
            let movieList = response.results
            self.todayMovieList = movieList
        } failureHandler: { afError, statusError in
            dump(afError)
            dump(statusError)
        }
    }
    
    override func setInitialValue() {
        navigationName = "Movie Box"
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppSFSymbol.magnifyingglass.image, style: .plain, target: self, action: #selector(navigateToSearchPage))
    }
    
    override func configureViewHierarchy() {
        
        [mainCard, searchHeaderView, buttonScrollView, secondTitleLabel, collectionView].forEach { view.addSubview($0) }
        [searchTitleLable,keywordDeleteButton ].forEach { searchHeaderView.addArrangedSubview($0) }
        buttonScrollView.addSubview(buttonContainer)
        
        recentlyUsedKeyword.enumerated().forEach { index, value in
            
            let button = CancellableButton(
                keyword: value,
                buttonAction: { 
                    print(#function)
                    self.navigateToSearchPage(keyword: value)
                },
                cancelAction: {
                    guard let index = self.recentlyUsedKeyword.firstIndex(of: value) else {
                        print("There is no \(value) in recent keyword")
                        return
                    }
                    
                    self.recentlyUsedKeyword.remove(at: index)
                    print(self.recentlyUsedKeyword)
                }
            )
            
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
        }
        
        buttonContainer.snp.makeConstraints {
            $0.height.equalTo(buttonScrollView.snp.height)
            $0.horizontalEdges.equalTo(buttonScrollView)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.top.equalTo(buttonScrollView.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(secondTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViewDetails() {
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        collectionView.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainCard.layer.cornerRadius = 10
    }
}

extension MainViewController {
    @objc func navigateToSearchPage(keyword: String?) {
        let destinationVC = SearchViewController()
        if let keyword = keyword {
            destinationVC.currentKeyoword = keyword
        }
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        todayMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieCollectionCell.id, for: indexPath) as? MainMovieCollectionCell {
            cell.fillUpData(movie: todayMovieList[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = todayMovieList[indexPath.item]
        
        
    }
}
