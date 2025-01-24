//
//  DesignSystem.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit


enum AppColor: String {
    case tintBlue = "0099D6"
    case mainBackground = "000000"
    case subBackground = "8e8e8e"
    case mainInfoDeliver = "fffff"
    case subInfoDeliver = "e1e1e1"
    
    var inUIColorFormat: UIColor {
        UIColor(hex: self.rawValue)
    }
}

// border Width
enum AppLineDesign: Int {
    case selected = 3
    case unselected = 1
}

enum AppSFSymbol: String {
    case camera = "camera.fill"
    case x = "xmark"
    case whiteHeart = "heart"
    case blackHeartd = "heart.fill"
    case calendar = "calendar"
    case magnifyingglass = "magnifyingglass"
    case star = "star.fill"
    case film = "film.fill"
}
