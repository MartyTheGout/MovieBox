//
//  ProfileViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/7/25.
//

import UIKit

class ProfileViewModel: BaseInOut {
    //MARK: - Information Architecture
    let iaDictionary: [String: String] = [
        "nav.push.title": "프로필 설정",
        "modal.title": "프로필 편집",
        "mbti.label": "MBTI",
        "button.text": "완료"
    ]
    
    //MARK: - Observable Properties
    
    struct Input {
        let nicknameInput : Observable<String?> = Observable(nil)
        let mbtiInputRecognizer = Observable(100)
        
        let registerButtonRecognizer : Observable<Void?> = Observable(nil)
        let modifyButtonRecognizer : Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        lazy var userProfileNumber : Observable<Int>  = {
            let currentlySavedData = ApplicationUserData.profileNumber
            let validInput = currentlySavedData == 100 ? Int.random(in: 0...11) : currentlySavedData
            
            return Observable(validInput)
        }()
        
        let nicknameValidationResult: Observable<(Bool, String, UIColor)?> = Observable(nil)
        
        let mbtiOutput1: Observable<MBTIPartial<MBTI1>> = Observable(MBTIPartial<MBTI1>.none)
        let mbtiOutput2: Observable<MBTIPartial<MBTI2>> = Observable(MBTIPartial<MBTI2>.none)
        let mbtiOutput3: Observable<MBTIPartial<MBTI3>> = Observable(MBTIPartial<MBTI3>.none)
        let mbtiOutput4: Observable<MBTIPartial<MBTI4>> = Observable(MBTIPartial<MBTI4>.none)
        let mbtiDoneInfo = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    //MARK: - ViewModel Initializer : data - closure binding
    init () {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.nicknameInput.bind { [weak self] newValue in
            guard let newValue else { return }
            self?.output.nicknameValidationResult.value = self?.validateNickname(with: newValue)
        }
        
        input.registerButtonRecognizer.bind { [weak self] _ in
            self?.registerUserData()
        }
        
        input.modifyButtonRecognizer.bind { [weak self] _ in
            self?.modifyUserData()
        }
        
        input.mbtiInputRecognizer.bind { [weak self] value in
            let locationInCategory = value % 2
            
            // 첫 설계에서 각각이 다른 타입을 가지게 되게끔 하였더니, 코드 재사용이 어려워졌다.
            switch value {
            case 0...1 :
                if self?.output.mbtiOutput1.value == .option(MBTI1(rawValue: locationInCategory)!) {
                    self?.output.mbtiOutput1.value = .none
                    return
                }
                
                self?.output.mbtiOutput1.value = .option(MBTI1(rawValue: locationInCategory)!)
                return
                
            case 2...3 :
                if self?.output.mbtiOutput2.value == .option(MBTI2(rawValue: locationInCategory)!) {
                    self?.output.mbtiOutput2.value = .none
                    return
                }
                
                self?.output.mbtiOutput2.value = .option(MBTI2(rawValue: locationInCategory)!)
                return
            case 4...5 :
                if self?.output.mbtiOutput3.value == .option(MBTI3(rawValue: locationInCategory)!) {
                    self?.output.mbtiOutput3.value = .none
                    return
                }
                
                self?.output.mbtiOutput3.value = .option(MBTI3(rawValue: locationInCategory)!)
                return
            case 6...7 :
                if self?.output.mbtiOutput4.value == .option(MBTI4(rawValue: locationInCategory)!) {
                    self?.output.mbtiOutput4.value = .none
                    return
                }
                
                self?.output.mbtiOutput4.value = .option(MBTI4(rawValue: locationInCategory)!)
                return
            default : return
            }
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
        guard let nickname = self.input.nicknameInput.value else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = self.output.userProfileNumber.value
        ApplicationUserData.registrationDate = Date()
        ApplicationUserData.firstLauchState = false
        
        // for the case of re-join the app
        if ApplicationUserData.withdrawalState {
            ApplicationUserData.withdrawalState = false
        }
    }
    
    func modifyUserData() {
        guard let nickname = self.input.nicknameInput.value else { return }
        ApplicationUserData.nickname = nickname
        ApplicationUserData.profileNumber = self.output.userProfileNumber.value
    }
    
    func checkMBTIAllFilled() {
        let mbti: [Int] = [
            output.mbtiOutput1.value.getRawInt(),
            output.mbtiOutput2.value.getRawInt(),
            output.mbtiOutput3.value.getRawInt(),
            output.mbtiOutput4.value.getRawInt()
        ]
        
        output.mbtiDoneInfo.value = mbti.allSatisfy { $0 != 2 }
    }
}

//MARK: - MBTI Types
enum MBTIPartial<T: MBTIDisplay> where T.RawValue == Int {
    case option(T)
    case none
    
    func getRawName() -> String? {
        switch self {
        case .option(let value): return value.getName()
        case .none : return nil
        }
    }
    
    func getRawInt() -> Int {
        switch self {
        case .option(let value) : return value.rawValue
        case .none : return 2
        }
    }
}

extension MBTIPartial: Equatable {
    static func == (lhs: MBTIPartial<T>, rhs: MBTIPartial<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none): return true
        case (.option(let a), .option(let b)): return a == b
        default: return false
        }
    }
}

protocol MBTIDisplay : RawRepresentable, Equatable where RawValue == Int {
    func getName() -> String
}

enum MBTI1: Int, MBTIDisplay, CaseIterable {
    case e = 0
    case i
    
    func getName() -> String {
        return "\(self)".uppercased()
    }
}

enum MBTI2: Int, MBTIDisplay, CaseIterable {
    case n = 0
    case s
    
    func getName() -> String {
        return "\(self)".uppercased()
    }
}

enum MBTI3: Int, MBTIDisplay, CaseIterable {
    case t = 0
    case f
    
    func getName() -> String {
        return "\(self)".uppercased()
    }
}

enum MBTI4: Int, MBTIDisplay, CaseIterable {
    case p = 0
    case j
    
    func getName() -> String {
        return "\(self)".uppercased()
    }
}
