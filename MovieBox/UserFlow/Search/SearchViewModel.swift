//
//  SearchViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation
import Alamofire

class SearchViewModel : BaseInOut {
    struct Input {
        let searchText: Observable<String?> = Observable(nil)
        let additionalSearchRequest: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let movieData: Observable<[Movie]?> = Observable(nil)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    var page = 1
    var availableNextFetching = true
    
    func transform() {
        input.searchText.lazybind { [weak self] oldQuery, query in
            self?.startSearchRequest(previousQuery: oldQuery, query: query)
            
            guard let query else { return }
            
            if !ApplicationUserData.recentlyUsedKeyword.contains(query) {
                ApplicationUserData.recentlyUsedKeyword.append(query)
            }
        }
        
        input.additionalSearchRequest.lazybind { [weak self] _ in
            guard let query = self?.input.searchText.value else { return }
            self?.page += 1
            self?.executeSearchEvent(queryString: query)
            self?.availableNextFetching = false // This line prevent from multiple request calling, which means, just one next request call per 20 data counts
        }
    }
}

extension SearchViewModel {
    func startSearchRequest(previousQuery: String? , query: String?) {
        guard let keyword = query else { return }
        if previousQuery == keyword {
            
        } else {
            // when being currentKeyword set from outside OR new keyword entered
            page = 1
            executeSearchEvent(queryString: keyword)
        }
    }
    
    func executeSearchEvent(queryString: String) {
        NetworkManager.shared.callRequest(apiKind: .search(query: queryString, page: page)) { (response: Result<SearchResponse, AFError>) -> Void in
            switch response {
            case .success(let value):
                if self.page > 1 {
                    self.output.movieData.value?.append(contentsOf: value.results)
                } else {
                    self.output.movieData.value = value.results
                }
                
                if self.page < value.totalPages {
                    self.availableNextFetching = true
                } else {
                    self.availableNextFetching = false
                }
            case .failure(let error):
                dump(error)
            }
        }
    }   
}
