//
//  LikeButtonViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/12/25.
//

import Foundation

class LikeButtonViewModel : BaseInOut {
    
    struct Input {
        var movieId: Observable<Int?> = Observable(nil)
        var likeGet: Observable<Void?> = Observable(nil)
        var likeUpdate: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        var likeStatus = Observable(false)
    }
    
    var input:Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.movieId.bind{ [weak self] _ in
            self?.input.likeGet.value = ()
        }
        
        input.likeGet.bind{ [weak self] _ in
            self?.getLikeStatus()
        }
        
        input.likeUpdate.bind{ [weak self] _ in
            self?.updateLikeStatus()
            self?.getLikeStatus()
        }
    }
}

extension LikeButtonViewModel  {
    func getLikeStatus() {
        guard let id = input.movieId.value else { return }
        
        let currentLikeStatus = ApplicationUserData.likedIdArray.contains(where: { $0 == id })
        output.likeStatus.value = currentLikeStatus
        
    }
    
    func updateLikeStatus() {
        guard let id = input.movieId.value else { return }
        
        if let idLocation = ApplicationUserData.likedIdArray.firstIndex(of: id) {
            ApplicationUserData.likedIdArray.remove(at: idLocation)
        } else {
            ApplicationUserData.likedIdArray.append(id)
        }
    }
}
