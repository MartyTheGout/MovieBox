//
//  AppColor.swift
//  MovieBox
//
//  Created by marty.academy on 3/28/25.
//


import UIKit

enum AppColor: String {
    case tintBrown = "301F1F"
    case mainBackground = "FDF6EC"
    case subBackground = "EDDBBF"
    case cardBackground = "DDC9AB"
    case mainInfoDeliver = "2F2F2F"
    case subInfoDeliver = "3E2723"
    case woodenConcept2 = "B36F50"
    
    case negativeMessage = "F04452"
    
    var inUIColorFormat: UIColor {
        UIColor(hex: self.rawValue)
    }
}
