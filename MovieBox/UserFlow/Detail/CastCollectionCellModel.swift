//
//  CastCollectionCellModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/12/25.
//

import Foundation

class CastCollectionCellModel: BaseInOut {
    struct Input  {
        
    }
    struct Output {
        let cast : Observable<Cast?> = Observable(nil)
    }
    
    var input : Input
    var output : Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {}
}
