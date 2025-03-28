//
//  MainViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit
import SkeletonView
import Alamofire

final class MainViewController: BaseViewController {
    
    let viewModel = MainViewModel()
    
    //MARK: - View Components
    let mainCard = MainCardView()
    
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
                .foregroundColor : AppColor.tintBrown.inUIColorFormat,
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
        stackView.spacing = 8
        
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
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    //MARK: View Controller LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainMovieCollectionCell.self, forCellWithReuseIdentifier: MainMovieCollectionCell.id)
        
        collectionView.isSkeletonable = true
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: AppColor.subBackground.inUIColorFormat), animation: animation, transition: .crossDissolve(1))
        
        setDataBindings()
        
        viewModel.input.movieGetRequest.value = ()
    }
    
    override func setInitialValue() {
        navigationName = "무비서랍"
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
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
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(10)
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
        mainCard.viewModel.input.refreshRequest.value = ()
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    private func clearAndRefetchRecentSearch() {
        viewModel.updateSearchHistoryOutput()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCard.layer.cornerRadius = 10
    }
}

//MARK: Collection + SkeletionCollectionView Protocol

extension MainViewController: SkeletonCollectionViewDelegate {}

extension MainViewController: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        MainMovieCollectionCell.id
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let todayMoviewList = viewModel.output.todayMovieList.value
        return todayMoviewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let todayMoviewList = viewModel.output.todayMovieList.value
        return todayMoviewList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainMovieCollectionCell.id, for: indexPath) as? MainMovieCollectionCell {
            cell.delegate = self
            
            let movie = viewModel.output.todayMovieList.value[indexPath.item]
            
            cell.viewModel.output.movie.value = movie
            cell.likeButtonViewModel.input.movieId.value = movie.id
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.output.todayMovieList.value[indexPath.item]
        let destinationVC = DetailViewController()
        destinationVC.viewModel.input.movie.value = movie
        destinationVC.likeButtonViewModel.input.movieId.value = movie.id
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: ReverseValueAssigning Protocol
extension MainViewController: ReverseValueAssigning {
    // for like button pressed from collectionviewcell
    func upstreamAction<T>(with: T) {
        if let _ = with as? Bool {
            mainCard.viewModel.input.refreshRequest.value = ()
        }
        
        if let _ = with as? UIColor {
            view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        }
    }
}

//MARK: Actions
extension MainViewController {
    
    func navigateToSearchPageWith(_ keyword: String) {
        let destinationVC = SearchViewController()
        destinationVC.viewModel.input.searchText.value = keyword
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func deleteSearchHistory() {
        viewModel.input.searchHistoryDeleteRequest.value = nil
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
        
        present(navigationController, animated: true)
    }
}

//MARK: - Data Bindings
extension MainViewController {
    func setDataBindings() {
        viewModel.output.todayMovieList.bind { [weak self] list in
            self?.collectionView.reloadData()
            
            if !list.isEmpty {
                self?.collectionView.stopSkeletonAnimation()
                self?.collectionView.hideSkeleton(reloadDataAfter: true)
            }
        }
        
        viewModel.output.recentlyUsedKeyword.bind { [weak self] keywords in
            self?.noresultLabel.isHidden =  keywords.count == 0 ? false : true
            
            self?.buttonContainer.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            keywords.enumerated().forEach { index, value in
                let button = CancellableButton(
                    keyword: value,
                    buttonAction: {
                        self?.navigateToSearchPageWith(value)
                    },
                    cancelAction: {
                        self?.viewModel.input.searchHistoryDeleteRequest.value = value
                    }
                )
                self?.buttonContainer.addArrangedSubview(button)
            }
        }
    }
}
