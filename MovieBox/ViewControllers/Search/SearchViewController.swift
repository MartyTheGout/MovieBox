//
//  SearchViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//
import UIKit
import SnapKit

final class SearchViewController: BaseViewController {

    var currentKeyoword : String?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Search View is under construction"
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "\(label.text)/ current keyword is \(currentKeyoword)"
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

}
