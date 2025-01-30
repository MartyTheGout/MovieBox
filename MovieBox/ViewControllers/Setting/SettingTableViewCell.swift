//
//  SettingTableViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit

class SettingTableViewCell : BaseTableViewCell {
    
    static var id : String {
        String(describing: self)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    override func configureViewHierarchy() {
        [titleLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configureViewLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    override func configureViewDetails() {
        contentView.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    func fillUpData(with title: String) {
        titleLabel.text = title
    }
}
