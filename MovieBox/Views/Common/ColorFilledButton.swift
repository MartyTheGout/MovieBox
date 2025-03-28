//
//  BlueBorderButton.swift
//  MovieBox
//
//  Created by marty.academy on 1/25/25.
//

import UIKit

class ColorFilledButton: UIButton {
    var title : String
    
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            
            self.backgroundColor = isEnabled ? AppColor.tintBrown.inUIColorFormat : AppColor.subBackground.inUIColorFormat
        }
    }
    
    init(title : String ) {
        self.title = title
        super.init(frame: .zero)
        configureButtonAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonAttribute() {
        
        let attributedString = NSAttributedString(string: title, attributes: [
            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor : UIColor.white
        ])
        self.setAttributedTitle(attributedString, for: .normal)
        
//        let attributedStringForDisabled = NSAttributedString(string: title, attributes: [
//            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
//            .foregroundColor : AppColor.subBackground.inUIColorFormat
//        ])
//        
//        self.setAttributedTitle(attributedStringForDisabled, for: .disabled)
    }
}
