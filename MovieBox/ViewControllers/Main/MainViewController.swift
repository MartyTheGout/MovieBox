//
//  MainViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    var recentlyUsedKeyword = ApplicationUserData.recentlyUsedKeyword
    
    let mainCard = MainCardView()
    
    lazy var todayMovieList: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: View Components
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
        let itemHeight : CGFloat = itemWidth * 1.7
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    //MARK: View Controller LifeCycle Functions
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
            $0.height.equalTo(35) // statically set, not to have dynamic layout displacement in under-layouts
        }
        
        noresultLabel.snp.makeConstraints {
            $0.top.equalTo(searchHeaderView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(buttonScrollView.snp.height)
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
        
        keywordDeleteButton.addTarget(self, action: #selector(deleteSearchHistory), for: .touchUpInside)
        
        toggleNoResultLabelState()
        
        mainCard.isUserInteractionEnabled = true
        let tapOnProfileCard = UITapGestureRecognizer(target: self, action: #selector(showProfileSheet))
        mainCard.addGestureRecognizer(tapOnProfileCard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearAndRefetchRecentSearch()
        
        if mainCard.likeCount != ApplicationUserData.likedIdArray.count {
            collectionView.reloadData()
        }
        mainCard.refreshViewData()
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    private func clearAndRefetchRecentSearch() {
        buttonContainer.subviews.forEach {
            $0.removeFromSuperview()
        }
        recentlyUsedKeyword = ApplicationUserData.recentlyUsedKeyword
        
        toggleNoResultLabelState()
        
        recentlyUsedKeyword.enumerated().forEach { index, value in
            
            let button = CancellableButton(
                keyword: value,
                buttonAction: {
                    self.navigateToSearchPageWith(value)
                },
                cancelAction: {
                    guard let index = ApplicationUserData.recentlyUsedKeyword.firstIndex(of: value) else {
                        print("There is no \(value) in recent keyword")
                        return
                    }
                    
                    ApplicationUserData.recentlyUsedKeyword.remove(at: index)
                    self.toggleNoResultLabelState()
                }
            )
            buttonContainer.addArrangedSubview(button)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCard.layer.cornerRadius = 10
    }
    
    private func toggleNoResultLabelState(){
        noresultLabel.isHidden =  recentlyUsedKeyword.count == 0 ? false : true
    }
}

//MARK: Collection Protocol
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        todayMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieCollectionCell.id, for: indexPath) as? MainMovieCollectionCell {
            cell.fillUpData(movie: todayMovieList[indexPath.item])
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = todayMovieList[indexPath.item]
        let destinationVC = DetailViewController()
        destinationVC.bringDetailData(data: movie)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: ReverseValueAssigning Protocol
extension MainViewController: ReverseValueAssigning {
    // for like button pressed from collectionviewcell
    func upstreamAction<T>(with: T) {
        if let _ = with as? Int {
            mainCard.refreshViewData()
        }
        
        if let _ = with as? UIColor {
            view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        }
        
    }
}

//MARK: Actions
extension MainViewController {
    @objc func navigateToSearchPage() {
        let destinationVC = SearchViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func navigateToSearchPageWith(_ keyword: String) {
        let destinationVC = SearchViewController()
        destinationVC.currentKeyword = keyword
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func deleteSearchHistory() {
        recentlyUsedKeyword = []
        ApplicationUserData.recentlyUsedKeyword = recentlyUsedKeyword
        
        buttonContainer.subviews.forEach { $0.removeFromSuperview() }
        toggleNoResultLabelState()
    }
    
    @objc func showProfileSheet() {
        let destinationVC = ProfileViewController(isModalPresentation: true)
        destinationVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true
        
        UIView.animate(withDuration: 1.0) {
            self.view.backgroundColor = AppColor.cardBackground.inUIColorFormat
        }
                
        present(UINavigationController(rootViewController: destinationVC), animated: true)
    }
}
