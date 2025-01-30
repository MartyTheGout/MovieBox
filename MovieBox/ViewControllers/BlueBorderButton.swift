//
//  BlueBorderButton.swift
//  MovieBox
//
//  Created by marty.academy on 1/25/25.
//

import UIKit

class BlueBorderButton: UIButton {
    var title : String
    
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            self.layer.borderColor = isEnabled ? AppColor.tintBlue.inUIColorFormat.cgColor : AppColor.subBackground.inUIColorFormat.cgColor
            self.layer.borderWidth = AppLineDesign.selected.rawValue
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
            .foregroundColor : AppColor.tintBlue.inUIColorFormat
        ])
        self.setAttributedTitle(attributedString, for: .normal)
        
        let attributedStringForDisabled = NSAttributedString(string: title, attributes: [
            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor : AppColor.subBackground.inUIColorFormat
        ])
        
        self.setAttributedTitle(attributedStringForDisabled, for: .disabled)
        
        getBlueBoldBorder(view: self)
    }
}
