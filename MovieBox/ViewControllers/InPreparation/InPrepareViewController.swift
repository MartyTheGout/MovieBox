//
//  InPrepareViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit

class InPrepareViewController: BaseViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22)
        label.text = "준비중이에요"
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        
        return label
    }()
    
    override func setInitialValue() {
        navigationName = "UPCOMING"
    }
    
    override func configureViewHierarchy() {
        view.addSubview(label)
    }
    
    override func configureViewLayout() {
        label.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
