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
    func configureViewDetails()
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
        configureViewDetails()
    }
    
    func setInitialValue(){}
    
    // As a default action, set navigationTitle and make back-button only chevron
    func configureNavigationBar() {
        
        //TODO: setting text is on the side of item, but setting color is on the side of navigationbar
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : AppColor.mainInfoDeliver.inUIColorFormat
        ]
        
        if let title = navigationName {
            navigationItem.title = title
        }

        //TODO: setting backButtonTitle didn't work. so did have to change the button it self.
        //Why the button cannot have the changed string. 
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    func configureViewHierarchy() {}
    func configureViewLayout() {}
    func configureViewDetails() {}
}

class BaseCollectionViewCell: UICollectionViewCell, DrawingEssentials {
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureViewHierarchy()
        configureViewLayout()
        configureViewDetails()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewDetails() {}
    
    func configureViewHierarchy() {}
    
    func configureViewLayout() {}
}
