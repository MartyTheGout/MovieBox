//
//  SearchTableViewCell.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class SearchTableViewCell: BaseTableViewCell {
    
    static var id : String { String (describing: self) }
    
    let viewModel = SearchTableCellModel()
    let likeButtonViewModel = LikeButtonViewModel()
    
    //MARK: View Components
    let mainImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppColor.mainInfoDeliver.inUIColorFormat
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = AppColor.subBackground.inUIColorFormat
        return label
    }()
    
    let genreStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    var likeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(AppSFSymbol.whiteHeart.image, for: .normal)
        button.tintColor = AppColor.tintBrown.inUIColorFormat
        return button
    }()
    
    //MARK: View Controller Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDataBindings()
    }
    
    override func configureViewHierarchy() {
        [mainImage, titleLabel, dateLabel, genreStack, likeButton].forEach{
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        mainImage.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(16)
            let width: CGFloat = UIScreen.main.bounds.width / 5
            $0.width.equalTo(width)
            $0.height.equalTo(mainImage.snp.width).multipliedBy(1.1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
            $0.trailing.equalTo(contentView).offset(-8)
        }
        
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
        }
        
        genreStack.snp.makeConstraints {
            $0.leading.equalTo(mainImage.snp.trailing).offset(16)
            $0.bottom.equalTo(contentView).offset(-16)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-16)
            $0.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    override func configureViewDetails() {
        contentView.backgroundColor = AppColor.mainBackground.inUIColorFormat
        likeButton.addTarget(self, action: #selector(updateLikeStatus), for: .touchUpInside)
        
        mainImage.isSkeletonable = true
        titleLabel.isSkeletonable = true
        dateLabel.isSkeletonable = true
        genreStack.isSkeletonable = true
        
        titleLabel.linesCornerRadius = 5
        dateLabel.linesCornerRadius = 5
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        mainImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: AppColor.subBackground.inUIColorFormat), animation: animation, transition: .crossDissolve(1))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10
        mainImage.layer.masksToBounds = true
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10
    }
}

//MARK: IncludingLike Protocol
extension SearchTableViewCell {
    @objc func updateLikeStatus() {
        likeButtonViewModel.input.likeUpdate.value = ()
    }
}

//MARK: Actions
extension SearchTableViewCell {
    private func getHighlightedString(originalText: String, keyword: String, mutableString: NSMutableAttributedString = NSMutableAttributedString(string: "")) -> NSAttributedString {
        let mutableString = mutableString
        
        guard let keywordRange = originalText.range(of: keyword) else {
            let attributedString = NSAttributedString(string: originalText, attributes: [
                .font : UIFont.systemFont(ofSize: 17, weight: .medium),
                .foregroundColor : AppColor.mainInfoDeliver.inUIColorFormat
            ])
            
            mutableString.append(attributedString)
            
            return mutableString
        }
        
        if originalText.startIndex == keywordRange.lowerBound {
            let keywordPart = originalText[keywordRange]
            let attributedString = NSAttributedString(string: String(keywordPart), attributes: [
                .font : UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor : AppColor.woodenConcept2.inUIColorFormat
            ])
            
            mutableString.append(attributedString)
            
            //**Be cautious : String.Range seeme like a..<b, which is not including the upper bound character. => so "next index" of upper bound can easily be out of String index
            return originalText.endIndex == keywordRange.upperBound ?
            mutableString :
            getHighlightedString(originalText: String(originalText[keywordRange.upperBound..<originalText.endIndex]), keyword: keyword, mutableString: mutableString)
            
        } else {
            let keywordBeforeIndex = originalText.index(before: keywordRange.lowerBound)
            let keywordBeforePart = originalText[originalText.startIndex...keywordBeforeIndex]
            
            let attributedStringBefore = NSAttributedString(string: String(keywordBeforePart), attributes: [
                .font : UIFont.systemFont(ofSize: 17, weight: .medium),
                .foregroundColor : AppColor.mainInfoDeliver.inUIColorFormat
            ])
            
            mutableString.append(attributedStringBefore)
            
            return getHighlightedString(originalText: String(originalText[keywordRange.lowerBound..<originalText.endIndex]), keyword: keyword, mutableString: mutableString)
        }
    }
}

//MARK: - Data Bindings
extension SearchTableViewCell {
    func setDataBindings() {
        viewModel.output.title.bind { [weak self] title in
            if let keyword = self?.viewModel.input.searchKeyword.value ,let textValue = title, textValue.contains(keyword) {
                self?.titleLabel.attributedText = self?.getHighlightedString(originalText: textValue, keyword: keyword)
            } else {
                self?.titleLabel.text = title
            }
            
            self?.titleLabel.numberOfLines = 2
        }
        
        viewModel.output.posterPath.bind { [weak self] posterPath in
            if let posterPath, !posterPath.isEmpty {
                self?.mainImage.kf.setImage(with: URL(string: Datasource.baseImageURL.rawValue + posterPath)!) { _ in
                    self?.mainImage.stopSkeletonAnimation()
                    self?.mainImage.hideSkeleton()
                    self?.mainImage.layer.cornerRadius = 10
                }
            } else {
                self?.mainImage.image = UIImage(systemName: "film")
                self?.mainImage.tintColor = AppColor.subBackground.inUIColorFormat
                self?.mainImage.contentMode = .scaleAspectFit
                
                self?.mainImage.stopSkeletonAnimation()
                self?.mainImage.hideSkeleton()
                self?.mainImage.layer.cornerRadius = 10
            }
        }
        
        viewModel.output.releaseDate.bind { [weak self] releaseDate in
            self?.dateLabel.text = releaseDate
        }
        
        viewModel.output.genreIDS.bind { [weak self] genreIDS in
            guard let genreIDS else { return }
            
            self?.genreStack.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            for genre in genreIDS {
                let genreInKorean = Genre(rawValue: genre)?.koreanName
                let genreView = GenreInfoView()
                genreView.backgroundColor = AppColor.cardBackground.inUIColorFormat
                genreView.viewModel.output.genreText.value = genreInKorean!
                
                self?.genreStack.addArrangedSubview(genreView)
            }
        }
        
        likeButtonViewModel.output.likeStatus.bind { [weak self] likeStatus in
            let image = likeStatus ? AppSFSymbol.blackHeart.image : AppSFSymbol.whiteHeart.image
            self?.likeButton.setImage(image, for: .normal)
        }
    }
}
