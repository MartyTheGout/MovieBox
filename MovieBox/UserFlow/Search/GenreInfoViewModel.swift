//
//  GenreInfoViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation

class GenreInfoViewModel: BaseInOut {
    struct Input {}
    struct Output {
        let genreText = Observable("")
    }
    
    var input: Input
    var output: Output
    
    init(){
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {}
}
