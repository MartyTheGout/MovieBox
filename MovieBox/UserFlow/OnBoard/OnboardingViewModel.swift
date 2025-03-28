//
//  OnboardingViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import Foundation
import UIKit

class OnboardingViewModel: BaseInOut {
    //MARK: - in-out pattern conformance ( Observable Properties )
    struct Input {}
    struct Output {}
    func transform() {}
    
    //MARK: - Information Architecture
    let iaDictionary: [String: String]  = [
        "titleLabel": "Onboarding",
        "subTitleLabel":"당신만의 영화 서랍,\n MovieSeorap를 열어보세요.",
        "button": "시작하기"
    ]
    
    //MARK: - Actions
    func getDestinationVC() -> UIViewController {
        ProfileViewController()
    }
}
