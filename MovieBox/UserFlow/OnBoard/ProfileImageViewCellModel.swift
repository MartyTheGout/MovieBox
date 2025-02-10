//
//  ProfileImageViewCellModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/9/25.
//

import Foundation

class ProfileImageViewCellModel: BaseInOut{
    
    //MARK: - in-out pattern conformance ( Observable Properties )
    var input : Input
    var output: Output
    
    struct Input {}
    struct Output {
        let isChosenInput = Observable(false)
    }
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {}
}
