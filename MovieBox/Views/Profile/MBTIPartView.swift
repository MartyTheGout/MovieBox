//
//  MBTIPartView.swift
//  MovieBox
//
//  Created by marty.academy on 2/9/25.
//

import UIKit

class MBTIPartView : BaseView {
    
    let verticalStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        
        return stack
    }()
    
    lazy var button1 : UIButton = {
        return getButton()
    }()
    
    lazy var button2 : UIButton = {
        return getButton()
    }()
    
    override func configureViewHierarchy() {
        addSubview(verticalStack)
        verticalStack.addArrangedSubview(button1)
        verticalStack.addArrangedSubview(button2)
    }
    
    override func configureViewLayout() {
        [button1, button2].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(50)
            }
        }
        
        verticalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureViewDetails() {}
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        [button1, button2].forEach {
            $0.layer.cornerRadius = 25
            $0.clipsToBounds = true
        }
    }
}

//MARK: - Actions
extension MBTIPartView {
    func getButton() -> UIButton {
        let button = UIButton()
        button.setTitle("", for: .normal)
        return button
    }
    
    func setText(mbtiCategory: [String]) {
        let buttonArray = [button1, button2]
        
        for i in 0...1 {
            buttonArray[i].setTitle(mbtiCategory[i], for: .normal)
        }
    }
    
    func setChosenPart(locationAt: Int?) {
        
        var buttonArray = [button1, button2]
        
        if let locationAt {
            let selectedButton = buttonArray.remove(at: locationAt)
            let leftButton = buttonArray[0]
            
            markSelected(button: selectedButton)
            
            markUnselected(button: leftButton)
        } else {
            [button1, button2].forEach {
                markUnselected(button: $0)
            }
        }
    }
    
    func markSelected(button : UIButton) {
        button.layer.borderWidth = 0
        button.backgroundColor = AppColor.tintBrown.inUIColorFormat
        button.setTitleColor(.white, for: .normal)
    }
    
    func markUnselected(button : UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.subBackground.inUIColorFormat.cgColor
        button.backgroundColor = .clear
        button.setTitleColor(AppColor.subBackground.inUIColorFormat, for: .normal)
    }
}
