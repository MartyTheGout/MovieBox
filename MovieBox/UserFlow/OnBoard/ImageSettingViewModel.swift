//
//  ImageSettingViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/9/25.
//

import Foundation

class ImageSettingViewModel {
    //MARK: - Information Architecture
    let iaDictionary: [String: String]  = [
        "nav.push.title": "프로필 이미지 설정",
        "modal.title": "프로필 이미지 편집",
    ]
    
    //MARK: - Observable Properties
    let userProfileNumber : Observable<Int>
    
    let selectionStatusArray = Observable(Array(repeating: false, count: 12))
    
    
    //MARK: - Protocol Related
    var delegate : ReverseValueAssigning?
    
    
    //MARK: - ViewModel Initializer : data - closure binding
    init(profileNumber: Int) {
        self.userProfileNumber = Observable(profileNumber)
        self.selectionStatusArray.value[profileNumber] = true
        
        userProfileNumber.lazybind { [weak self] oldValue, newValue in
            self?.selectionStatusArray.value[newValue] = true
            self?.selectionStatusArray.value[oldValue] = false
        }
    }
}
