//
//  MainCardViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/11/25.
//

import Foundation

class MainCardViewModel : BaseInOut {
    struct Input {
        let refreshRequest: Observable<Void?> = Observable(nil)
    }
    struct Output {
        let profileImageAsset = Observable(ApplicationUserData.profileNumber)
        let nickname = Observable(ApplicationUserData.nickname)
        let date = Observable(ApplicationUserData.registrationDate)
        let likeCount = Observable(ApplicationUserData.likedIdArray.count)
    }
    
    var input : Input
    var output : Output
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.refreshRequest.bind { [weak self] _ in
            self?.refreshApplicationUserData()
        }
    }
}

//MARK: - Actions
extension MainCardViewModel {
    func refreshApplicationUserData() {
        output.nickname.value = ApplicationUserData.nickname
        output.date.value = ApplicationUserData.registrationDate
        output.likeCount.value = ApplicationUserData.likedIdArray.count
        output.profileImageAsset.value = ApplicationUserData.profileNumber
    }
    
    func convertDateToFormattedData (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd 가입"
        
        return dateFormatter.string(from: date)
    }
}
