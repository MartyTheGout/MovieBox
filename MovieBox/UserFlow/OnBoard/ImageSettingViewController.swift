//
//  ImageSettingView.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

final class ImageSettingViewController : BaseViewController {
        
    var userData : Int {
        didSet {
            selectedStatusArray[userData] = true
            selectedStatusArray[oldValue] = false
            
            selectedProfile.changeImage(userData: userData)
        }
    }
    
    var delegate : ReverseValueAssigning
    
    var selectedStatusArray = Array(repeating: false, count: 12) {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var selectedProfile = SelectedProfileView(userData: self.userData)
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let spacing : CGFloat = 8
        let numberOfItemsPerRow : CGFloat = 4
        let sizeOnAxis : CGFloat = ( UIScreen.main.bounds.width - (numberOfItemsPerRow + 1) * spacing) / numberOfItemsPerRow
        
        flowLayout.itemSize = CGSize(width: sizeOnAxis, height: sizeOnAxis)
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
    }()

    init(userData:Int, delegate: ReverseValueAssigning) {
        self.userData = userData
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageViewCell.self, forCellWithReuseIdentifier: ProfileImageViewCell.id)
    }
    
    override func setInitialValue() {
        if let _ = presentingViewController {
            navigationName = "프로필 이미지 편집"
        } else {
            navigationName = "프로필 이미지 설정"
        }
        
        selectedStatusArray[userData] = true
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.backAction = UIAction(title: "", state: .on) { _ in
            self.delegate.upstreamAction(with: self.userData)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func configureViewHierarchy() {
        [selectedProfile, collectionView].forEach { view.addSubview($0)}
    }
    
    override func configureViewLayout() {
        selectedProfile.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.size.equalTo(120)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(selectedProfile.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViewDetails() {
        
        let backgroundColor = AppColor.mainInfoDeliver.inUIColorFormat
        
        view.backgroundColor = backgroundColor
        collectionView.backgroundColor = backgroundColor
    }
}

extension ImageSettingViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedStatusArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageViewCell.id, for: indexPath) as? ProfileImageViewCell {
            cell.setCellImage(locationAt: indexPath.item)
            cell.isChosen = selectedStatusArray[indexPath.item]
            
            cell.contentView.isUserInteractionEnabled = false // This line of code can prevent button from coverting contentView's clickable area
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userData = indexPath.item
    }
}

