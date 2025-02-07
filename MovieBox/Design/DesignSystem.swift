//
//  DesignSystem.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

enum AppColor: String {
    case tintBlue = "186FF2"
    case mainBackground = "000000"
    case subBackground = "8C8C8C"
    case cardBackground = "2F2F2F"
    case mainInfoDeliver = "FFFFFF"
    case subInfoDeliver = "E1E1E1"
    
    case negativeMessage = "F04452"
    
    var inUIColorFormat: UIColor {
        UIColor(hex: self.rawValue)
    }
}

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
