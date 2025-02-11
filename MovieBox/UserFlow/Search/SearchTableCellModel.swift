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
        let likeGet: Observable<Void?> = Observable(nil)
        let likeUpdate: Observable<Void?> = Observable(nil)
    }
    struct Output {
        let posterPath: Observable<String?> = Observable(nil)
        let likeStatus =  Observable(false)
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
        
        input.likeGet.lazybind { [weak self] _ in
            self?.getLikeStatus()
        }
        
        input.likeUpdate.lazybind { [weak self] _ in
            self?.updateLikeStatus()
        }
    }
}

//MARK: - Actions
extension SearchTableCellModel {
    func convertMovieToOutputs(with movie: Movie? ) {
        input.likeGet.value = ()
        
        guard let movie else { return }
        
        output.posterPath.value = movie.posterPath
        output.title.value = movie.title
        output.releaseDate.value = movie.releaseDate
        
        // Application Spec: visible genre is up to 2 items.
        let value = movie.genreIDS?.prefix(2) ?? []
        
        output.genreIDS.value = Array(value) // ArraySlice to Array
    }
    
    func getLikeStatus() {
        guard let id = input.movie.value?.id else { return }
        
        let currentLikeStatus = ApplicationUserData.likedIdArray.contains(where: { $0 == id })
        output.likeStatus.value = currentLikeStatus
    }
    
    func updateLikeStatus() {
        guard let id = input.movie.value?.id else { return }
        
        if let idLocation = ApplicationUserData.likedIdArray.firstIndex(of: id) {
            ApplicationUserData.likedIdArray.remove(at: idLocation)
        } else {
            ApplicationUserData.likedIdArray.append(id)
        }
    }
}
