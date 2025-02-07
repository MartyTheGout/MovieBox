//
//  ProfileViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import Foundation

class ProfileViewModel {
    let userProfileNumber : Observable<Int> = Observable(ApplicationUserData.profileNumber)
}
