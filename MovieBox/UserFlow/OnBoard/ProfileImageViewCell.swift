//
//  ProfileImageViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

final class ProfileImageViewCell: BaseCollectionViewCell {
    
    static var id : String {
        String(describing: self)
    }
    
    let viewModel = ProfileImageViewCellModel()
    
    //MARK: - View Components
    lazy var button: UIButton = {
        let button = UIButton()
        getBlueBoldBorder(view: button)
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataBindings()
    }
    
    //MARK: - View Life Cycle
    override func configureViewHierarchy() {
        contentView.addSubview(button)
    }
    
    override func configureViewLayout() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = button.frame.height / 2
    }
}

//MARK: - Actions
extension ProfileImageViewCell {
    func setCellImage(locationAt: Int) {
        button.setImage(UIImage(named: "profile_\(locationAt)"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
}

//MARK: - DataBindings
extension ProfileImageViewCell {
    func setDataBindings() {
        viewModel.output.isChosenInput.bind { [weak self] value in
            guard let button = self?.button else { return }
            if value {
                getBlueBoldBorder(view: button)
                button.alpha = 1
            } else {
                button.layer.borderWidth = AppLineDesign.unselected.rawValue
                button.layer.borderColor = AppColor.subBackground.inUIColorFormat.cgColor
                button.alpha = 0.5
            }
        }
    }
}
