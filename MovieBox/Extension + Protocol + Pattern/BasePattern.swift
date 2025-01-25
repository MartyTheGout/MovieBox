//
//  BasePattern.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

protocol DrawingEssentials {
    func configureViewHierarchy()
    func configureViewLayout()
}

class BaseView: UIView, DrawingEssentials {
        override init(frame: CGRect) {
            super.init(frame: .zero)
    
            configureViewHierarchy()
            configureViewLayout()
            configureViewDetails()
        }
    
    func configureViewHierarchy() {}
    func configureViewLayout() {}
    func configureViewDetails() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BaseViewController: UIViewController, DrawingEssentials {
    
    var navigationName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValue()
        
        configureNavigationBar()
        
        configureViewHierarchy()
        configureViewLayout()
    }
    
    func setInitialValue(){}
    
    // As a default action, set navigationTitle and make back-button only chevron
    func configureNavigationBar() {
        if let title = navigationName {
            navigationItem.title = navigationName
        }
        
        navigationItem.backBarButtonItem?.title = ""
    }
    func configureViewHierarchy() {}
    func configureViewLayout() {}
}
