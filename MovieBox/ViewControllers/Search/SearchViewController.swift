//
//  SearchViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//
import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    var currentKeyword : String? {
        didSet {
            guard let keyword = currentKeyword else { return }
            if searchBar.text == currentKeyword {
            
            } else {
                // when being currentKeyword set from outside
                searchBar.text = keyword
                executeSearchEvent(queryString: keyword)
            }
        }
    }
    
    var isFirstSearch = false // for search with keyword entrance
    var page = 1
    var availableNextFetching = true
    
    var data: [Movie] = [] {
        didSet {
            tableView.reloadData()
            handleSearchResultOnView()
        }
    }
    
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
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        
        if let keyword = currentKeyword {
            searchBar.text = keyword
        } else {
            searchBar.searchTextField.becomeFirstResponder()
        }
        
        noResultView.isHidden = true
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
    }
    
    private func handleSearchResultOnView() {
        if data.isEmpty {
            noResultView.isHidden = false
        } else {
            noResultView.isHidden = true
        }
    }
}

//MARK: TableView Protocol
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id) as? SearchTableViewCell {
            cell.fillUpData(with: data[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageHeight: CGFloat = ( UIScreen.main.bounds.width / 5 ) * 1.1
        return imageHeight + 16 * 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = data[indexPath.row]
        let destinationVC = DetailViewController()
        
        //upStreamValueChange is for reflecting like-status change in DetailVC to SearchVC's tableView-row
        destinationVC.upstreamValueChange = {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        destinationVC.bringDetailData(data: movie)
    
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension SearchViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.item > data.count - 5 && availableNextFetching {
                guard let keyword = currentKeyword else { return }
                page += 1
                executeSearchEvent(queryString: keyword)
                availableNextFetching = false // This line prevent from multiple request calling, which means, just one next request call per 20 data counts
            }
        }
    }
}

//MARK: SearchBarDelegate Protocol
extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        executeSearchEvent(queryString: keyword)
        
        if !ApplicationUserData.recentlyUsedKeyword.contains(keyword) {
            ApplicationUserData.recentlyUsedKeyword.append(keyword)
        }
        
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
}

//MARK: Actions
extension SearchViewController {
    func executeSearchEvent(queryString: String) {
        
        if queryString != currentKeyword {
            page = 1
        }
        
        NetworkManager.shared.callRequest(apiKind: .search(query: queryString, page: page)) { (response: SearchResponse) -> Void in
              
            if queryString == self.currentKeyword {
                self.data.append(contentsOf: response.results)
            } else {
                self.data = response.results
                if !self.data.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    self.page = 1
                }
            }
        
            self.currentKeyword = queryString
            
            if self.page < response.totalPages {
                self.availableNextFetching = true
            } else {
                self.availableNextFetching = false
            }
        } failureHandler: { afError, responseError in
            dump(afError)
            dump(responseError)
        }
    }
}
