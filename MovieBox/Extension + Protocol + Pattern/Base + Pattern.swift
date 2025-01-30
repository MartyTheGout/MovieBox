//
//  BasePattern.swift
//  MovieBox
//
//  Created by marty.academy on 1/24/25.
//

import UIKit

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

class BaseTableViewCell : UITableViewCell, DrawingEssentials {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViewHierarchy()
        configureViewLayout()
        configureViewDetails()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewHierarchy() {}
    
    func configureViewLayout() {}
    
    func configureViewDetails() {}
}


class BaseScrollViewController: UIViewController, DrawingEssentials {
    
    var navigationName : String?
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValue()
        
        configureNavigationBar()
        
        configureScrollToContentHierarchy()
        configureScrollToContentLayout()
        
        configureViewHierarchy()
        configureViewLayout()
        
        attachingContentViewToBottomElement()
        
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
    
    func configureScrollToContentHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func configureScrollToContentLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.verticalEdges.equalTo(scrollView)
        }
    }
    
    func configureViewHierarchy() {}
    
    func configureViewLayout() {}
    func configureViewDetails() {}
    
    func attachingContentViewToBottomElement() {
        guard let lastTarget = contentView.subviews.last else {
            print("[Ambiguous] There is no element to attach to the bottom of contentView")
            return
        }
        
        contentView.snp.makeConstraints {
            $0.bottom.equalTo(lastTarget.snp.bottom)
        }
    }
}
