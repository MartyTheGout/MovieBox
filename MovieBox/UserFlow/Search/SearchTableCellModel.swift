//
//  SearchTableCellModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation

class SearchTableCellModel : BaseInOut {
    struct Input {
        let searchKeyword: Observable<String?> = Observable(nil)
        let movie: Observable<Movie?> = Observable(nil)
    }
    struct Output {
        let posterPath: Observable<String?> = Observable(nil)
        let title: Observable<String?> = Observable(nil)
        let releaseDate: Observable<String?> = Observable(nil)
        let genreIDS: Observable<[Int]?> = Observable(nil)
    }
    
    var input: Input
    var output: Output
    
    init(){
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.movie.bind { [weak self] movie in
            self?.convertMovieToOutputs(with: movie)
        }
    }
}

//MARK: - Actions
extension SearchTableCellModel {
    func convertMovieToOutputs(with movie: Movie? ) {
        guard let movie else { return }
        
        output.posterPath.value = movie.posterPath
        output.title.value = movie.title
        output.releaseDate.value = movie.releaseDate
        
        // Application Spec: visible genre is up to 2 items.
        let value = movie.genreIDS?.prefix(2) ?? []
        
        output.genreIDS.value = Array(value) // ArraySlice to Array
    }
}
