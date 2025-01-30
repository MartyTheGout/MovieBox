//
//  ApplicationUserData.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

@propertyWrapper
struct UserDefault<T> {
    var key: String
    var defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: self.key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
}

enum ApplicationUserData {
    @UserDefault(key: "FIRST_LAUCH_STATE", defaultValue: true) // 독립적으로 보이지만, 4가지의 경우의 수가 존재하지 않는다. ** 
    static var firstLauchState: Bool
    
    @UserDefault(key: "WITHDRAWAL_STATE", defaultValue: false)
    static var withdrawalState: Bool {
        didSet {
            if withdrawalState {
                profileNumber = 100
                nickname = ""
                likedIdArray = []
                recentlyUsedKeyword = []
            }
        }
    }
    
    @UserDefault(key: "PROFILE_NUMBER", defaultValue: 100)
    static var profileNumber: Int
    
    @UserDefault(key: "NICKNAME", defaultValue: "")
    static var nickname: String
    
    @UserDefault(key: "REGISTRATION_DATE", defaultValue: Date())
    static var registrationDate: Date
    
    @UserDefault(key: "LIKED_ID_ARRAY", defaultValue: [])
    static var likedIdArray: [Int]
    
    @UserDefault(key: "RECENTLY_USED_KEYWORD", defaultValue: [])
    static var recentlyUsedKeyword: [String]
    
    static func changeLauchState() {
        firstLauchState.toggle()
    }
    
    static func changeWithdrawlState() {
        withdrawalState.toggle()
    }
    
    static func withdraw() {
        withdrawalState = true
    }
}

