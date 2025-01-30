//
//  DetailViewController.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: BaseScrollViewController {
    var movieId: Int?
    var movieName : String? {
        didSet {
            configureNavigationBar()
        }
    }
    
    var likeButton: UIButton = UIButton() //TODO: Developing protocol including the usecase that like-button is located in navigation bar as right bar button.
    
    var backDropImages : [UIImageView] = []
    var posterImages: [UIImageView] = []
    
    let firstViewHeight : CGFloat = UIScreen.main.bounds.width * (2 / 3)
    
    let posterWidth = ( UIScreen.main.bounds.width - ( 3 * 16) * 2 ) / 3
    lazy var posterHeight = posterWidth * (1.5)
    
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
        let pageControl = UIPageControl() // frame required?
        
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
        let attributedTitle = NSAttributedString(string: "More", attributes: [.foregroundColor : AppColor.tintBlue.inUIColorFormat])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backDropScrollView.delegate = self
    }
    
    override func setInitialValue() {
        navigationName = movieName
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: AppSFSymbol.whiteHeart.image, style: .plain, target: self, action: #selector(updateLikeStatus))
    }
    
    override func configureViewHierarchy() {
        [backDropScrollView, pageControl, movieInfoStack,synopsisTitleLabel, synopsisButton, synopsisContentLabel, posterLable, posterScrollView].forEach {
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
        
        posterLable.snp.makeConstraints {
            $0.top.equalTo(synopsisContentLabel.snp.bottom).offset(16)
            $0.leading.equalTo(contentView).offset(16)
        }

        posterScrollView.snp.makeConstraints {
            $0.top.equalTo(posterLable.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(posterHeight)
        }

        posterContentView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(posterScrollView)
            $0.height.equalTo(posterScrollView)
        }
    }
    
    override func configureViewDetails() {
        guard let movieId else { return }
        showLikeStatus(id: movieId)
        synopsisButton.addTarget(self, action: #selector(toggleSynosisDisplayOption), for: .touchUpInside)
    }
    
    func configureMovieInfoStack () {
        let imagesInOrder = [AppSFSymbol.calendar.image, AppSFSymbol.star.image, AppSFSymbol.filmSingle.image]
        
        imagesInOrder.enumerated().forEach { index, image in
            let contentLabel = UILabel()
            
            let imageAttachment = NSTextAttachment(image: image.withTintColor(AppColor.subBackground.inUIColorFormat))
            let mutableString = NSMutableAttributedString(string: "")
            mutableString.append(NSAttributedString(attachment: imageAttachment))
            mutableString.append(NSAttributedString(string: " "))
            
            contentLabel.attributedText = mutableString
            
            movieInfoStack.addArrangedSubview(contentLabel)
            
            if index != imagesInOrder.count - 1 {
                let barLabel = UILabel()
                barLabel.attributedText = NSAttributedString(string: "|", attributes: [.foregroundColor : AppColor.subBackground.inUIColorFormat])
                movieInfoStack.addArrangedSubview(barLabel)
            }
        }
    }
}

extension DetailViewController: IncludingLike {
    @objc func updateLikeStatus() {
        guard let id = movieId else {
            print("[not-proper assignment] id is not set properly")
            return
        }
        
        if let idLocation = ApplicationUserData.likedIdArray.firstIndex(of: id) {
            ApplicationUserData.likedIdArray.remove(at: idLocation)
        } else {
            ApplicationUserData.likedIdArray.append(id)
        }
        
        showLikeStatus(id: id)
    }
    
    func showLikeStatus(id: Int) {
        let image = ApplicationUserData.likedIdArray.contains(id) ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
        navigationItem.rightBarButtonItem?.setImage(image, options: .init(.none))
    }
}

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

extension DetailViewController {
    /**
    This function **dynamically** bring datasource for views, including 5 backdrop images, inifite poster images, details about movie.
            
    The point of this function is that, since the composition of this view is mainly affected by scrollview, which has no automatic data-reload functionality,  **not only the data, but also the layout, hierarchy of the view,  should be modified**
     
     So the overflow of this function is as below.
     data update with given one > data fetching > (if required) Add up the view in the view heirarchy  > (if required) Add up layout constraints
     */
    func bringDetailData(data: Movie) {
        self.movieId = data.id
        self.movieName = data.title
        
        let genreIDs: String = (data.genreIDS?.prefix(2).reduce("", { result, element in
            guard let genre = Genre(rawValue: element) else {return result}
            
            if result != "" {
                return result + ", " + genre.koreanName
            }
            
            return result + genre.koreanName
        }))!
            
        let infoStack: [String] = [data.releaseDate ?? "", "\(data.voteAverage ?? 0.0)", genreIDs]
        configureMovieInfoStack()
        
        movieInfoStack.subviews.enumerated().forEach { (index, label)  in
            guard let label = label as? UILabel else {
                print("there is no label in movieInfoStack")
                return }
            
            if index % 2 == 0 {
                let previousAttributeString = label.attributedText?.copy() as? NSAttributedString
                
                let mutableString = NSMutableAttributedString(string: "")
                mutableString.append(previousAttributeString!)
                mutableString.append(NSAttributedString(string: infoStack[index/2],
                                                        attributes: [
                                                            .foregroundColor : AppColor.subBackground.inUIColorFormat,
                                                            .font : UIFont.systemFont(ofSize: 15)
                                                        ]))
                
                label.attributedText = mutableString
            }
        }
        
        synopsisContentLabel.text = data.overview
        
        NetworkManager.shared.callRequest(apiKind: .image(movieId: data.id)) { (imageResponse: ImageResponse) -> Void in
            let backdrops = imageResponse.backdrops.prefix(5)
            let posters = imageResponse.posters
        
            backdrops.forEach {
                let imageURL = Datasource.baseImageURL.rawValue + $0.filePath
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: imageURL)!)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                
                self.backDropImages.append(imageView)
                self.backDropContentView.addSubview(imageView)
            }
            
            var horizontalCoordinateBase: ConstraintRelatableTarget = self.backDropContentView
            self.backDropContentView.subviews.forEach { subView in
                subView.snp.makeConstraints {
                    $0.top.equalTo(self.backDropContentView)
                    $0.leading.equalTo(horizontalCoordinateBase)
                    $0.width.equalTo(UIScreen.main.bounds.width)
                    $0.height.equalTo(UIScreen.main.bounds.width * (2/3))
                }
                
                horizontalCoordinateBase = subView.snp.trailing
            }
            
            // make backDropContentView have same trailing with the last sub image.
            self.backDropContentView.snp.makeConstraints {
                $0.trailing.equalTo(horizontalCoordinateBase)
            }

            posters.forEach {
                let imageURL = Datasource.baseImageURL.rawValue + $0.filePath
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: imageURL)!)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.contentMode = .scaleToFill
                
                self.posterImages.append(imageView)
                self.posterContentView.addArrangedSubview(imageView)
            }
            
            self.posterContentView.subviews.forEach { subView in
                subView.snp.makeConstraints {
                    $0.width.equalTo(self.posterWidth)
                    $0.height.equalTo(self.posterHeight)
                }
            }
        } failureHandler: { afError, httpResponseError in
            dump(afError)
            dump(httpResponseError.description)
        }
    }
    
    @objc func toggleSynosisDisplayOption(_ sender: UIButton) {
        
        guard let text = sender.titleLabel?.text else { return }
        
        if text.lowercased() == "more" {
            synopsisContentLabel.numberOfLines = 0

            let attributedTitle = NSAttributedString(string: "Hide", attributes: [.foregroundColor : AppColor.tintBlue.inUIColorFormat])
            synopsisButton.setAttributedTitle(attributedTitle, for: .normal)
            
        } else {
            synopsisContentLabel.numberOfLines = 3
            
            let attributedTitle = NSAttributedString(string: "More", attributes: [.foregroundColor : AppColor.tintBlue.inUIColorFormat])
            synopsisButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
}
