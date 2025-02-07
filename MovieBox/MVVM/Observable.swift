//
//  Observable.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import Foundation

class Observable<T> {
    var value : T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var closure : ( (T) -> Void )? = { _ in }
    
    func bind (_ closure : @escaping ( (T) -> Void ) ) {
        self.closure = closure
        closure(value)
    }
    
    func lazybind(_ closure: @escaping( (T) -> Void)) {
        self.closure = closure
    }
}
