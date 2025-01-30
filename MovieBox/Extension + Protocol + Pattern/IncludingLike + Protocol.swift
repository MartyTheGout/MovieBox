//
//  IncludingLIke.swift
//  MovieBox
//
//  Created by marty.academy on 1/28/25.
//

import UIKit

protocol IncludingLike {
    var movieId : Int? { get set }
    var likeButton : UIButton { get set }
    
    func updateLikeStatus()
    func showLikeStatus(id: Int)
}
