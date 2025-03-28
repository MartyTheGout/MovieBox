//
//  ImageSettingView.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit
import SnapKit

final class ImageSettingViewController : BaseViewController {
    
    var viewModel : ImageSettingViewModel
    
    //MARK: - View Components
    lazy var selectedProfile = SelectedProfileView(userData: self.viewModel.input.userProfileNumber.value)
    
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
        self.viewModel = ImageSettingViewModel(profileNumber: userData)
        self.viewModel.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageViewCell.self, forCellWithReuseIdentifier: ProfileImageViewCell.id)
        
        setDataBindings()
    }
    
    override func setInitialValue() {
        if let _ = presentingViewController {
            navigationName = viewModel.iaDictionary["modal.title"]
        } else {
            navigationName = viewModel.iaDictionary["nav.push.title"]
        }
    }
    
    override func configureNavigationBar() {        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : AppColor.mainBackground.inUIColorFormat
        ]
        
        if let title = navigationName {
            navigationItem.title = title
        }
        
        navigationItem.backAction = UIAction(title: "", state: .on) { _ in
            self.viewModel.delegate?.upstreamAction(with: self.viewModel.input.userProfileNumber.value)
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
        
        let backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        view.backgroundColor = backgroundColor
        collectionView.backgroundColor = backgroundColor
    }
}

//MARK: Collection Protocol
extension ImageSettingViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.output.selectionStatusArray.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageViewCell.id, for: indexPath) as? ProfileImageViewCell {
            
            cell.setCellImage(locationAt: indexPath.item)
            
            cell.viewModel.output.isChosenInput.value = viewModel.output.selectionStatusArray.value[indexPath.item]
            
            cell.contentView.isUserInteractionEnabled = false // This line of code can prevent button from coverting contentView's clickable area
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.userProfileNumber.value = indexPath.item
    }
}

//MARK: - Data Bindings
extension ImageSettingViewController {
    func setDataBindings () {
        viewModel.output.selectionStatusArray.lazybind { [weak self] value in
            guard let currentSelectedIndex = self?.viewModel.input.userProfileNumber.value else {
                return
            }
            
            self?.selectedProfile.changeImage(userData: currentSelectedIndex)
            self?.collectionView.reloadData()
        }
    }
}
