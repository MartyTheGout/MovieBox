//
//  BlueBorderButton.swift
//  MovieBox
//
//  Created by marty.academy on 1/25/25.
//

import UIKit

class BlueBorderButton: UIButton {
    var title : String
    
    init(title : String ) {
        self.title = title
        super.init(frame: .zero)
        configureButtonAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonAttribute() {
        let attributedString = NSAttributedString(string: "시작하기", attributes: [
            .font : UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor : AppColor.tintBlue.inUIColorFormat
        ])
        self.setAttributedTitle(attributedString, for: .normal)
        self.layer.borderColor = AppColor.tintBlue.inUIColorFormat.cgColor
        self.layer.borderWidth = AppLineDesign.selected.rawValue
    }
}
