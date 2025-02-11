//
//  genreView.swift
//  MovieBox
//
//  Created by marty.academy on 1/28/25.
//

import UIKit
import SnapKit

final class GenreInfoView: BaseView {
    
    let viewModel = GenreInfoViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataBindings()
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
}

//MARK: - Data Bindings
extension GenreInfoView {
    func setDataBindings() {
        viewModel.output.genreText.bind { [weak self] text in
            self?.label.text = text
        }
    }
}
