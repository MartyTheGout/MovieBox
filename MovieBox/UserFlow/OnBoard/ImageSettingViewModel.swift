//
//  ImageSettingViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/9/25.
//

import Foundation

class ImageSettingViewModel: BaseInOut {
    
    //MARK: - in-out pattern conformance ( Observable Properties )
    var input : Input
    var output : Output
    
    struct Input {
        let userProfileNumber : Observable<Int>
        
        init(userProfileNumber: Int) {
            self.userProfileNumber = Observable(userProfileNumber)
        }
    }
    
    struct Output {
        let selectionStatusArray = Observable(Array(repeating: false, count: 12))
    }
    
    //MARK: - Information Architecture
    let iaDictionary: [String: String]  = [
        "nav.push.title": "프로필 이미지 설정",
        "modal.title": "프로필 이미지 편집",
    ]
    
    //MARK: - Protocol Related
    var delegate : ReverseValueAssigning?
    
    
    //MARK: - ViewModel Initializer : data - closure binding
    init(profileNumber: Int) {
        
        self.input = Input(userProfileNumber: profileNumber)
        self.output = Output()
        
        self.output.selectionStatusArray.value[profileNumber] = true
        
        transform()
    }
    
    func transform() {
        input.userProfileNumber.lazybind { [weak self] oldValue, newValue in
            self?.output.selectionStatusArray.value[newValue] = true
            self?.output.selectionStatusArray.value[oldValue] = false
        }
    }
}
