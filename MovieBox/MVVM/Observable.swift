//
//  Observable.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import Foundation

class Observable<T> {
    enum Observer {
        case newValueType( (T) -> Void)
        case newAndOldValueType((T, T)-> Void)
    }
    
    private var observer : Observer?
    
    var value : T {
        didSet {
            switch observer {
            case .newValueType(let closure):
                closure(value)
            case .newAndOldValueType(let closure):
                closure(oldValue, value)
            case nil:
                break
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind (_ closure : @escaping ( (T) -> Void ) ) {
        self.observer = .newValueType(closure)
        closure(value)
    }
    
    func lazybind(_ closure: @escaping( (T) -> Void)) {
        self.observer = .newValueType(closure)
    }
    
    func lazybind (_ closure : @escaping ( (T, T) -> Void ) ) {
        self.observer = .newAndOldValueType(closure)
    }
}
