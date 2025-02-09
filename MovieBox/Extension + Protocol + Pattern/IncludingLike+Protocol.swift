//
//  IncludingLIke.swift
//  MovieBox
//
//  Created by marty.academy on 1/28/25.
//

import UIKit

protocol LikeButton {}

extension UIButton: LikeButton {}
extension UIBarButtonItem : LikeButton {}

protocol IncludingLike {
    var movieId : Int? { get set }
    
    associatedtype ButtonType: LikeButton
    var likeButton : ButtonType { get set }
    
    func updateLikeStatus()
    func showLikeStatus(id: Int)
}
