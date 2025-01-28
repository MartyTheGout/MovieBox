//
//  genreView.swift
//  MovieBox
//
//  Created by marty.academy on 1/28/25.
//

import UIKit

class GenreInfoView: BaseView {
    
    let label = {
        let label = UILabel()
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.font = UIFont.systemFont(ofSize: 13)
        label.layer.cornerRadius = label.frame.height / 2
        return label
    }()
    
    override func configureViewHierarchy() {
        addSubview(label)
    }
    
    override func configureViewLayout() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func fillupData(text : String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
}
