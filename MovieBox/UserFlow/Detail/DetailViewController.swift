//
//  DetailViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

final class DetailViewController: BaseScrollViewController {
    
    let viewModel = DetailViewModel()
    let likeButtonViewModel = LikeButtonViewModel()
    
    lazy var likeButton: UIBarButtonItem = {
        return UIBarButtonItem(image: AppSFSymbol.whiteHeart.image.withTintColor(AppColor.woodenConcept2.inUIColorFormat, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(updateLikeStatus))
    }()
    
    var upstreamValueChange : (()->Void)?
    
    let firstViewHeight : CGFloat = UIScreen.main.bounds.width * (2 / 3)
    
    let posterWidth = ( UIScreen.main.bounds.width - ( 3 * 16) * 2 ) / 3
    lazy var posterHeight = posterWidth * (1.5)
    
    
    //MARK: View Components
    let backDropScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bouncesZoom = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.tag = 0
        return scrollView
    }()
    
    let backDropContentView = UIView()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    let movieInfoStack : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    let synopsisTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "Synopsis"
        return label
    }()
    
    let synopsisButton: UIButton = {
        let button = UIButton ()
        let attributedTitle = NSAttributedString(string: "More", attributes: [
            .foregroundColor : AppColor.tintBrown.inUIColorFormat,
            .font : UIFont.systemFont(ofSize: 15)
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    let synopsisContentLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = AppColor.subInfoDeliver.inUIColorFormat
        label.numberOfLines = 3
        return label
    }()
    
    let castLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "Cast"
        return label
    }()
    
    let castCollection : UICollectionView = {
        let flowLayout = LeadingAlignedFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let width: CGFloat = (UIScreen.main.bounds.width - (24 * 3)) / 2
        let height: CGFloat = 58 // image height : 50 + top/bottom inset 8's
        
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    let posterLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        label.text = "Poster"
        return label
    }()
    
    let posterScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bouncesZoom = true
        return scrollView
    }()
    
    let posterContentView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backDropScrollView.delegate = self
        
        castCollection.delegate = self
        castCollection.dataSource = self
        castCollection.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        
        setDataBindings()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.rightBarButtonItem = likeButton
    }
    
    override func configureViewHierarchy() {
        [backDropScrollView, pageControl, movieInfoStack,synopsisTitleLabel, synopsisButton, synopsisContentLabel,castLabel, castCollection, posterLable, posterScrollView].forEach {
            contentView.addSubview($0)
        }
        
        backDropScrollView.addSubview(backDropContentView)
        posterScrollView.addSubview(posterContentView)
    }
    
    override func configureViewLayout() {
        backDropScrollView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view)
            $0.top.equalTo(contentView).offset(16)
            $0.height.equalTo(firstViewHeight)
        }
        
        backDropContentView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(backDropScrollView)
            $0.height.equalTo(backDropScrollView)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(backDropScrollView)
        }
        
        movieInfoStack.snp.makeConstraints {
            $0.top.equalTo(backDropScrollView.snp.bottom).offset(8)
            $0.centerX.equalTo(contentView)
        }
        
        synopsisTitleLabel.snp.makeConstraints {
            $0.top.equalTo(movieInfoStack.snp.bottom).offset(24)
            $0.leading.equalTo(contentView).offset(16)
        }
        
        synopsisButton.snp.makeConstraints {
            $0.top.equalTo(movieInfoStack.snp.bottom).offset(24)
            $0.trailing.equalTo(contentView).offset(-16)
        }
        
        synopsisContentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(synopsisTitleLabel.snp.bottom).offset(16)
        }
        
        castLabel.snp.makeConstraints {
            $0.top.equalTo(synopsisContentLabel.snp.bottom).offset(24)
            $0.leading.equalTo(contentView).offset(16)
        }
        
        castCollection.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(contentView).inset(8)
            $0.height.equalTo(125) // precise height = 120 + required buffer for estimated size
        }
        
        posterLable.snp.makeConstraints {
            $0.top.equalTo(castCollection.snp.bottom).offset(16)
            $0.leading.equalTo(contentView).offset(16)
        }
        
        posterScrollView.snp.makeConstraints {
            $0.top.equalTo(posterLable.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(posterHeight)
        }
        
        posterContentView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(posterScrollView).inset(16)
            $0.height.equalTo(posterScrollView)
        }
    }
    
    override func configureViewDetails() {
        view.backgroundColor = AppColor.mainBackground.inUIColorFormat
        
        synopsisButton.addTarget(self, action: #selector(toggleSynosisDisplayOption), for: .touchUpInside)
        castCollection.backgroundColor = AppColor.mainBackground.inUIColorFormat
    }
    
    func configureMovieInfoStack () {
        let imagesInOrder = [AppSFSymbol.calendar.image, AppSFSymbol.star.image, AppSFSymbol.filmSingle.image]
        
        imagesInOrder.enumerated().forEach { index, image in
            let contentLabel = UILabel()
            
            let imageAttachment = NSTextAttachment(image: image.withTintColor(AppColor.subInfoDeliver.inUIColorFormat))
            let mutableString = NSMutableAttributedString(string: "")
            mutableString.append(NSAttributedString(attachment: imageAttachment))
            mutableString.append(NSAttributedString(string: " "))
            
            contentLabel.attributedText = mutableString
            
            movieInfoStack.addArrangedSubview(contentLabel)
            
            if index != imagesInOrder.count - 1 {
                let barLabel = UILabel()
                barLabel.attributedText = NSAttributedString(string: "|", attributes: [.foregroundColor : AppColor.subInfoDeliver.inUIColorFormat])
                movieInfoStack.addArrangedSubview(barLabel)
            }
        }
    }
}


//MARK: Like Feature
extension DetailViewController {
    @objc func updateLikeStatus() {
        likeButtonViewModel.input.likeUpdate.value = ()
        upstreamValueChange?()
    }
}

//MARK: ScrollDelegate Protocol
extension DetailViewController: UIScrollViewDelegate {
    /**
     This function is for chaning page-control corresponding to the movement of x coordinate in backdrop scroll view
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 && fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
}

//MARK: CollectionDelegate/DataSource Protocol
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let casts = viewModel.output.castInfo.value else { return 0 }
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as? CastCollectionViewCell {
            guard let casts = viewModel.output.castInfo.value else { return UICollectionViewCell() }
            cell.viewModel.output.cast.value = casts[indexPath.item]

            return cell
        }
        
        return UICollectionViewCell()
    }
}

//MARK: Actions
extension DetailViewController {
    
    @objc func toggleSynosisDisplayOption(_ sender: UIButton) {
        
        guard let text = sender.titleLabel?.text else { return }
        
        if text.lowercased() == "more" {
            synopsisContentLabel.numberOfLines = 0
            
            let attributedTitle = NSAttributedString(string: "Hide", attributes: [.foregroundColor : AppColor.tintBrown.inUIColorFormat])
            synopsisButton.setAttributedTitle(attributedTitle, for: .normal)
            
        } else {
            synopsisContentLabel.numberOfLines = 3
            
            let attributedTitle = NSAttributedString(string: "More", attributes: [.foregroundColor : AppColor.tintBrown.inUIColorFormat])
            synopsisButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
}

//MARK: - Data Bindings
extension DetailViewController {
    
    func setDataBindings() {
        viewModel.output.movieName.bind { [weak self] name in
            self?.navigationName = name
            self?.configureNavigationBar()
        }
        
        viewModel.output.overview.bind { [weak self] overview in
            self?.synopsisContentLabel.text = overview
        }
        
        viewModel.output.infoStack.bind { [weak self] infoStack in
            self?.configureMovieInfoStack()
            
            self?.movieInfoStack.subviews.enumerated().forEach { (index, label)  in
                guard let label = label as? UILabel else {
                    print("there is no label in movieInfoStack")
                    return }
                
                if index % 2 == 0 {
                    let previousAttributeString = label.attributedText?.copy() as? NSAttributedString
                    
                    let mutableString = NSMutableAttributedString(string: "")
                    mutableString.append(previousAttributeString!)
                    mutableString.append(NSAttributedString(string: infoStack[index/2],
                                                            attributes: [
                                                                .foregroundColor : AppColor.subInfoDeliver.inUIColorFormat,
                                                                .font : UIFont.systemFont(ofSize: 15)
                                                            ]))
                    
                    label.attributedText = mutableString
                }
            }
        }
        
        viewModel.output.backdropImageUrls.lazybind { [weak self] backdrops in
            if backdrops.isEmpty {
                let imageView = UIImageView()
                imageView.image = UIImage(systemName: "film")
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = AppColor.subInfoDeliver.inUIColorFormat
                
                self?.backDropContentView.addSubview(imageView)
                
            } else { // 여기부터 
                backdrops.forEach {
                    let imageURL = Datasource.baseImageURL.rawValue + $0
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: URL(string: imageURL)!)
                    imageView.clipsToBounds = true
                    imageView.contentMode = .scaleAspectFill
                    
                    self?.backDropContentView.addSubview(imageView)
                }
            }
            
            // initially number is set to 5, but in case of less than 5 => need to set to precise value
            self?.pageControl.numberOfPages = self?.backDropContentView.subviews.count ?? 0
            
            guard let backDropContentView = self?.backDropContentView else { return }
            var horizontalCoordinateBase: ConstraintRelatableTarget = backDropContentView
            
            self?.backDropContentView.subviews.forEach { subView in
                subView.snp.makeConstraints {
                    $0.top.equalTo(backDropContentView)
                    $0.leading.equalTo(horizontalCoordinateBase)
                    $0.width.equalTo(UIScreen.main.bounds.width)
                    $0.height.equalTo(UIScreen.main.bounds.width * (2/3))
                }
                
                horizontalCoordinateBase = subView.snp.trailing
            }
            
            // make backDropContentView have same trailing with the last sub image.
            self?.backDropContentView.snp.makeConstraints {
                $0.trailing.equalTo(horizontalCoordinateBase)
            }
        }
        
        viewModel.output.posterImageUrls.lazybind { [weak self] posters in
            if posters.isEmpty {
                let imageView = UIImageView()
                imageView.image = UIImage(systemName: "film")
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = AppColor.subBackground.inUIColorFormat
                
                self?.posterContentView.addArrangedSubview(imageView)
                
            } else {
                posters.forEach {
                    let imageURL = Datasource.baseImageURL.rawValue + $0
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: URL(string: imageURL)!)
                    imageView.clipsToBounds = true
                    imageView.contentMode = .scaleToFill
                    
                    self?.posterContentView.addArrangedSubview(imageView)
                }
            }
            
            self?.posterContentView.subviews.forEach { subView in
                subView.snp.makeConstraints {
                    $0.width.equalTo(self?.posterWidth ?? 0)
                    $0.height.equalTo(self?.posterHeight ?? 0)
                }
            }
        }
        
        viewModel.output.castInfo.bind { [weak self] castInfo in
            self?.castCollection.reloadData()
        }
        
        likeButtonViewModel.output.likeStatus.bind { [weak self]  isLiked in
            let image = isLiked ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
            self?.navigationItem.rightBarButtonItem?.setImage(image.withTintColor(AppColor.woodenConcept2.inUIColorFormat, renderingMode: .alwaysOriginal), options: .init(.none))
        }
    }
}

