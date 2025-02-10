//
//  BaseInOut.swift
//  MovieBox
//
//  Created by marty.academy on 2/10/25.
//

import Foundation

protocol BaseInOut {
    
    associatedtype Input
    associatedtype Output
    
    func transform()
}
