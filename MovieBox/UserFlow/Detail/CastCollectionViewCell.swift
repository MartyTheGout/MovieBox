//
//  CastCollectionViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class CastCollectionViewCell: BaseCollectionViewCell {
    
    let viewModel = CastCollectionCellModel()
    
    static var id: String {
        String(describing: self)
    }
    
    //MARK: - View Components
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let realNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    let charactorNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = AppColor.subBackground.inUIColorFormat
        return label
    }()
    
    //MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataBindings()
    }
    
    override func configureViewHierarchy() {
        [imageView, realNameLabel, charactorNameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        imageView.snp.makeConstraints{
            $0.top.leading.equalTo(contentView).inset(4)
            $0.size.equalTo(50)
            $0.bottom.equalTo(contentView).offset(-4)
        }
        
        realNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView).offset(-8)
        }
        
        charactorNameLabel.snp.makeConstraints {
            $0.top.equalTo(realNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView).offset(-8)
        }
    }
    
    override func configureViewDetails() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    /**
     Background of this function: All of the trials below were failed, Therefore It was required to put logic to modify cornerRadius on the last step, in drawing cycle
    Since the imageView's size was set in the phase of viewDidLoad,
     1) Tried to set cornerRadious at configureViewDetails
     2) Tried to set cornerRadious at fillUpData, so that the cornerRadius can be changed right after the image was set
     3) Tried to set cornerRadious at layoutSubViews
     
     with some try the order of function call was below, but didn't worked.
     * configureViewDetails() -> fillUpData() -> layoutSubviews()
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
}

//MARK: - Data Bindings
extension CastCollectionViewCell {
    func setDataBindings() {
        viewModel.output.cast.bind { [weak self] cast in
            
            guard let cast else { return }
            
            if cast.character == "-" {
                self?.imageView.image = UIImage(systemName: "person.circle")
                self?.imageView.contentMode = .scaleAspectFit
                self?.imageView.tintColor = AppColor.subBackground.inUIColorFormat
            } else {
                if let profilePath = cast.profilePath {
                    let imageURL = URL(string: Datasource.baseImageURL.rawValue + (profilePath))
                    self?.imageView.kf.setImage(with: imageURL)
                } else {
                    self?.imageView.image = UIImage(systemName: "person.circle")
                    self?.imageView.contentMode = .scaleAspectFit
                    self?.imageView.tintColor = AppColor.subBackground.inUIColorFormat
                }
            }
            
            self?.realNameLabel.text = cast.name
            self?.charactorNameLabel.text = cast.character
        }
    }
}
