//
//  DetailViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit

final class DetailViewController: BaseViewController {

    var data: TrendingMovie?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Detail View is under construction"
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureViewHierarchy() {
        [label].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func configureViewDetails() {
        view.backgroundColor = .black
    }
}
