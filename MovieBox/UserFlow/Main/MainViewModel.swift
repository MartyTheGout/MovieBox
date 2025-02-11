//
//  MainViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation
import Alamofire

class MainViewModel : BaseInOut {
    struct Input {
        let movieGetRequest: Observable<Void?> = Observable(nil)
        let searchHistoryDeleteRequest: Observable<String?> = Observable(nil)
    }
    
    struct Output {
        let recentlyUsedKeyword = Observable(ApplicationUserData.recentlyUsedKeyword)
        let todayMovieList = Observable<[Movie]>([])
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.movieGetRequest.bind { [weak self] _ in
            self?.getTrendMovie()
        }
        input.searchHistoryDeleteRequest.bind { [weak self] value in
            self?.deleteSearchHistory(of: value)
        }
    }
    
    func getTrendMovie () {
        NetworkManager.shared.callRequest( apiKind: .trending ) { (response : Result<TrendingResponse, AFError>) -> Void in
            switch response {
            case .success(let value):
                let movieList = value.results
                self.output.todayMovieList.value = movieList
            case.failure(let error):
                dump(error)
            }
        }
    }
    
    // nil => delete all data in array / string => delete one data in array
    func deleteSearchHistory(of: String?) {
        guard let keyword = of else {
            ApplicationUserData.recentlyUsedKeyword.removeAll()
            updateSearchHistoryOutput()
            return
        }
        
        guard let indexInArray = output.recentlyUsedKeyword.value.firstIndex(where: {$0 == keyword}) else { return }
        
        var capturedArray = output.recentlyUsedKeyword.value
        capturedArray.remove(at: indexInArray)
        
        ApplicationUserData.recentlyUsedKeyword = capturedArray
        updateSearchHistoryOutput()
    }
    
    func updateSearchHistoryOutput() {
        output.recentlyUsedKeyword.value = ApplicationUserData.recentlyUsedKeyword
    }
}
