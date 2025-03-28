//
//  DesignSystem.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit



// border Width
enum AppLineDesign: CGFloat {
    case selected = 3
    case unselected = 1
}

enum AppSFSymbol: String {
    case camera = "camera.fill"
    case x = "xmark"
    case whiteHeart = "heart"
    case blackHeart = "heart.fill"
    case calendar = "calendar"
    case magnifyingglass = "magnifyingglass"
    case star = "star.fill"
    case film = "film.stack"
    case filmSingle = "film"
    case popcorn = "popcorn"
    case person = "person.circle"
    case chevronRight = "chevron.right"
    
    var image : UIImage {
        UIImage(systemName: self.rawValue)!
    }
}
