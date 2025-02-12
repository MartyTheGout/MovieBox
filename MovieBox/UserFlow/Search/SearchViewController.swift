//
//  SearchViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//
import UIKit
import SnapKit
import SkeletonView
import Alamofire

final class SearchViewController: BaseViewController {
    let viewModel = SearchViewModel()
   
    //MARK: View Components
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = AppColor.mainBackground.inUIColorFormat
        searchBar.searchTextField.leftView?.tintColor = AppColor.subInfoDeliver.inUIColorFormat
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요.", attributes: [.foregroundColor: AppColor.subInfoDeliver.inUIColorFormat])
        searchBar.searchTextField.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        
        return searchBar
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = AppColor.mainBackground.inUIColorFormat
        return tableView
    }()
    
    let noResultView : UIView = {
        let uiView = UIView()
        
        let noResultSentence = "원하는 검색결과를 찾지 못했습니다."
        let label = UILabel()
        label.textColor = AppColor.subBackground.inUIColorFormat
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.text = noResultSentence
        
        uiView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalTo(uiView)
        }
        
        return uiView
    }()
    
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        
        if let _ = viewModel.input.searchText.value {
        } else {
            searchBar.searchTextField.becomeFirstResponder()
        }
        
        noResultView.isHidden = true
        
        setDataBindings()
    }
    
    override func setInitialValue() {
        navigationName = "영화 검색"
    }
    
    override func configureViewHierarchy() {
        [searchBar, tableView, noResultView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noResultView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViewDetails() {
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        tableView.separatorStyle = .none
        
        tableView.isSkeletonable = true
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: AppColor.subBackground.inUIColorFormat), animation: animation, transition: .crossDissolve(1))
    }
    
    private func handleSearchResultOnView() {
        guard let movieData = viewModel.output.movieData.value else { return }
        
        if movieData.isEmpty {
            noResultView.isHidden = false
        } else {
            noResultView.isHidden = true
        }
    }
}

//MARK: TableView + Skeleton Protocol
extension SearchViewController: SkeletonTableViewDelegate {}


extension SearchViewController : SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ collectionSkeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movieData = viewModel.output.movieData.value else { return 0 }
        return movieData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchTableViewCell.id
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movieData = viewModel.output.movieData.value else { return 0 }
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as? SearchTableViewCell {
            guard let movieData = viewModel.output.movieData.value else { return UITableViewCell() }
            
            cell.viewModel.input.searchKeyword.value = viewModel.input.searchText.value
            cell.viewModel.input.movie.value = movieData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight: CGFloat = ( UIScreen.main.bounds.width / 5 ) * 1.1
        return imageHeight + 16 * 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let movieData = viewModel.output.movieData.value else { return }
        
        let movie = movieData[indexPath.row]
        let destinationVC = DetailViewController()
        
        //upStreamValueChange is for reflecting like-status change in DetailVC to SearchVC's tableView-row
        destinationVC.upstreamValueChange = {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        destinationVC.viewModel.input.movie.value = movie
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension SearchViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            guard let movieData = viewModel.output.movieData.value else { return }
            
            if index.item > movieData.count - 5 && viewModel.availableNextFetching {
                viewModel.input.additionalSearchRequest.value = ()
            }
        }
    }
}

//MARK: SearchBarDelegate Protocol
extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        // Business Logic
        viewModel.input.searchText.value = keyword
        
        // View
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
}

//MARK: - Data Bindings
extension SearchViewController {
    func setDataBindings() {
        viewModel.output.movieData.lazybind { [weak self] oldData, newData in
            
            guard let newData else { return }
            
            if !newData.isEmpty {
                self?.tableView.stopSkeletonAnimation()
                self?.tableView.hideSkeleton()
                
                if newData.count <= 20 {
                    if self?.tableView.numberOfSections ?? 0 > 0 {
                        DispatchQueue.main.async {
                            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) // WHY? 이전 코드에서는 비동기 처리할 필요가 없었다.
                        }
                    }
                    
                    if self?.searchBar.text == "" {
                        self?.searchBar.text = self?.viewModel.input.searchText.value
                    }
                }
                
                self?.tableView.reloadData()
            }
            
            self?.handleSearchResultOnView()
        }
    }
}
