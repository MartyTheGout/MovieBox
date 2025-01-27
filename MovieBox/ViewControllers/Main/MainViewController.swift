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
    
    lazy var todayMovieList: [TrendingMovie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedKeyword: String = ""
    
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
        label.textColor = AppColor.subBackground.inUIColorFormat
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
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
        
        NetworkManager.shared.callRequest( apiKind: .trending ) { (response : TrendingResponse) -> Void in
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
        
        [mainCard, searchHeaderView, buttonScrollView,noresultLabel, secondTitleLabel, collectionView].forEach { view.addSubview($0) }
        [searchTitleLable,keywordDeleteButton ].forEach { searchHeaderView.addArrangedSubview($0) }
        buttonScrollView.addSubview(buttonContainer)
        
        recentlyUsedKeyword.enumerated().forEach { index, value in
            
            let button = CancellableButton(
                keyword: value,
                buttonAction: {
                    print(#function)
                    self.navigateToSearchPageWith(value)
                },
                cancelAction: {
                    guard let index = self.recentlyUsedKeyword.firstIndex(of: value) else {
                        print("There is no \(value) in recent keyword")
                        return
                    }
                    
                    self.recentlyUsedKeyword.remove(at: index)
                    print(self.recentlyUsedKeyword)
                    
                    self.toggleNoResultLabelState()
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
        }
        
        noresultLabel.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(buttonScrollView.snp.height) //TODO: 버튼이 사라졌을 때에, 다른뷰에는 변화가 없는 것처럼 하고싶다.
        }
        
        buttonContainer.snp.makeConstraints {
            $0.height.equalTo(buttonScrollView.snp.height)
            $0.horizontalEdges.equalTo(buttonScrollView)
        }
        
        secondTitleLabel.snp.makeConstraints {
            $0.top.equalTo(buttonScrollView.snp.bottom).offset(16)
            $0.top.equalTo(noresultLabel.snp.bottom).offset(16)
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
        
        keywordDeleteButton.addTarget(self, action: #selector(deleteSearchHistory), for: .touchUpInside)
        
        toggleNoResultLabelState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainCard.layer.cornerRadius = 10
    }
    
    private func toggleNoResultLabelState(){
        noresultLabel.isHidden =  recentlyUsedKeyword.count == 0 ? false : true
    }
}

extension MainViewController {
    @objc func navigateToSearchPage() {
        let destinationVC = SearchViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func navigateToSearchPageWith(_: String) {
        let destinationVC = SearchViewController()
        destinationVC.currentKeyoword = selectedKeyword
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func deleteSearchHistory() {
        recentlyUsedKeyword = []
        ApplicationUserData.recentlyUsedKeyword = recentlyUsedKeyword
        
        buttonContainer.subviews.forEach { $0.removeFromSuperview() }
        toggleNoResultLabelState()
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
        let destinationVC = DetailViewController()
        destinationVC.data = movie
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
