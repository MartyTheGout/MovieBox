//
//  OnboardingViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import Foundation
import UIKit

class OnboardingViewModel {
    let ioTextDictionary: [String: String]  = [
        "titleLabel": "Onboarding",
        "subTitleLabel":"당신만의 영화 세상,\n MovieBox를 시작해보세요.",
        "button": "시작하기"
    ]
    
    func getDestinationVC() -> UIViewController {
        ProfileViewController()
    }
}
