//
//  SearchViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//
import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    
    var currentKeyoword : String?
    var page = 1
    
    var data: [SearchedMovie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "찾고 싶은 영화를 검색해주세요."
        return searchBar
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        
        NetworkManager.shared.callRequest(apiKind: .search(query: "소닉", page: page)) { (response: SearchResponse) -> Void in
            self.data = response.results
        } failureHandler: { afError, responseError in
            dump(afError)
            dump(responseError)
        }
    }
    
    override func setInitialValue() {
        navigationName = "영화 검색"
    }
    
    override func configureViewHierarchy() {
        [searchBar, tableView].forEach {
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
    }
    
    override func configureViewDetails() {
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        searchBar.barTintColor = AppColor.mainBackground.inUIColorFormat
        
        tableView.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
}

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
}

extension SearchViewController : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {}
}

