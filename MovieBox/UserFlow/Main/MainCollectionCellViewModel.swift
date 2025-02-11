//
//  MainCollectionCellViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation

class MainCollectionCellViewModel : BaseInOut {
    struct Input {
        let likeUpdate: Observable<Void?> = Observable(nil)
        let likeGet: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let movie : Observable<Movie?> = Observable(nil)
        let likeStatus = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.likeGet.lazybind { [weak self] _ in
            self?.getLikeStatus()
        }
        
        input.likeUpdate.lazybind { [weak self] _ in
            self?.updateLikeStatus()
            self?.getLikeStatus( )
        }
    }
}

extension MainCollectionCellViewModel {
    func getLikeStatus() {
        guard let id = output.movie.value?.id else { return }
        
        let currentLikeStatus = ApplicationUserData.likedIdArray.contains(where: { $0 == id })
        output.likeStatus.value = currentLikeStatus
    }
    
    func updateLikeStatus() {
        guard let id = output.movie.value?.id else { return }
        
        if let idLocation = ApplicationUserData.likedIdArray.firstIndex(of: id) {
            ApplicationUserData.likedIdArray.remove(at: idLocation)
        } else {
            ApplicationUserData.likedIdArray.append(id)
        }
    }
}
