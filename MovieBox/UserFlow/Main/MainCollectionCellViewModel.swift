//
//  MainCollectionCellViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation

class MainCollectionCellViewModel : BaseInOut {
    struct Input {}
    
    struct Output {
        let movie : Observable<Movie?> = Observable(nil)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {}
}
