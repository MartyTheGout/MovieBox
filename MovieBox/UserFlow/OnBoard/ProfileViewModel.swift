//
//  ProfileViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import UIKit

class ProfileViewModel {
    //MARK: - Information Architecture
    let iaDictionary: [String: String] = [
        "nav.push.title": "프로필 설정",
        "modal.title": "프로필 편집",
        "button.text": "완료"
    ]
    
    //MARK: - Observable Properties
    lazy var userProfileNumber : Observable<Int>  = {
        let currentlySavedData = ApplicationUserData.profileNumber
        let validInput = currentlySavedData == 100 ? Int.random(in: 0...11) : currentlySavedData
        
        return Observable(validInput)
    }()
    
    let nicknameInput : Observable<String?> = Observable(nil)
    let nicknameValidationResult: Observable<(Bool, String, UIColor)?> = Observable(nil)
    
    let registerButtonRecognizer : Observable<Void?> = Observable(nil)
    let modifyButtonRecognizer : Observable<Void?> = Observable(nil)
    
    //MARK: - ViewModel Initializer : data - closure binding
    init () {
        nicknameInput.bind { [weak self] newValue in
            guard let newValue else { return }
            self?.nicknameValidationResult.value = self?.validateNickname(with: newValue)
        }
        
        registerButtonRecognizer.bind { [weak self] _ in
            self?.registerUserData()
        }
        
        modifyButtonRecognizer.bind { [weak self] _ in
            self?.modifyUserData()
        }
    }
    
    //MARK: - Observable's Closure
    func validateNickname(with input: String) -> (Bool, String, UIColor) {
        
        let negativeColor = AppColor.negativeMessage.inUIColorFormat
        
        if input.contains(/[@|#|$|%]/) {
            return (false, "닉네임는 @, #, $, % 는 포함할 수 없어요", negativeColor)
        }
        
        if input.contains(/\d/) {
            return (false, "닉네임에 숫자는 포함할 수 없어요.", negativeColor)
        }
        
        if input.count >= 2 && input.count < 10 {
            return (true, "사용할 수 있는 닉네임이에요.", AppColor.tintBlue.inUIColorFormat)
        } else {
            return (false, "2글자 이상 10글자 미만으로 설정해주세요.", negativeColor)
        }
    }
    
    func registerUserData() {
        guard let nickname = self.nicknameInput.value else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = self.userProfileNumber.value
        ApplicationUserData.registrationDate = Date()
        ApplicationUserData.firstLauchState = false
     
        // for the case of re-join the app
        if ApplicationUserData.withdrawalState {
            ApplicationUserData.withdrawalState = false
        }
    }
    
    func modifyUserData() {
        guard let nickname = self.nicknameInput.value else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = self.userProfileNumber.value
    }
}
