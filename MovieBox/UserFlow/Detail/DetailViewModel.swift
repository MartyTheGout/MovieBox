//
//  DetailViewModel.swift
//  MovieBox
//
//  Created by marty.academy on 2/12/25.
//

import Foundation
import Alamofire

class DetailViewModel: BaseInOut {
    //MARK: - in-out pattern conformance ( Observable Properties )8
    struct Input {
        let movie : Observable<Movie?> = Observable(nil)
    }
    
    struct Output {
        let movieName: Observable<String?> = Observable(nil)
        let infoStack: Observable<[String]> = Observable([])
        let overview: Observable<String?> = Observable(nil)
        
        let backdropImageUrls: Observable<[String]> = Observable([])
        let posterImageUrls: Observable<[String]> = Observable([])
        
        let castInfo : Observable<[Cast]?> = Observable(nil)
    }
    
    var input : Input
    var output : Output
    
    init () {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.movie.bind { [weak self] movie in
            guard let movie else { return }
            
            self?.output.movieName.value = movie.title
            self?.setInfoStack(with: movie)
            self?.output.overview.value = movie.overview
            
            self?.getImageInfo(with: movie.id)
            self?.getCastInfo(with: movie.id)
        }
    }
}

//MARK: - Actions
extension DetailViewModel {
    
    func setInfoStack(with movie: Movie) {
        let genreIDs: String = (movie.genreIDS?.prefix(2).reduce("", { result, element in
            guard let genre = Genre(rawValue: element) else {return result}
            
            if result != "" {
                return result + ", " + genre.koreanName
            }
            
            return result + genre.koreanName
        }))!
        
        let infoStack: [String] = [movie.releaseDate ?? "", "\(movie.voteAverage ?? 0.0)", genreIDs]
        self.output.infoStack.value = infoStack
    }
    
    func getImageInfo(with id : Int) {
        NetworkManager.shared.callRequest(apiKind: .image(movieId: id)) { (imageResponse: Result<ImageResponse, AFError>) -> Void in
            
            switch imageResponse {
            case .success(let value):
                let backdrops: [String] = value.backdrops.prefix(5).map{ $0.filePath }
                let posters = value.posters.map { $0.filePath }
                
                self.output.backdropImageUrls.value = backdrops
                self.output.posterImageUrls.value = posters
                
            case.failure(let error):
                dump(error)
            }
        }
    }
    
    func getCastInfo(with id : Int) {
        NetworkManager.shared.callRequest(apiKind: .credit(movieId: id)) { (response: Result<CreditResponse, AFError> )-> Void in
            switch response {
            case .success(let value) :
                if value.cast.isEmpty {
                    let emptyCastRepresentative = Cast(name: "No Data", character: "-", profilePath: "")
                    self.output.castInfo.value = [emptyCastRepresentative]
                } else {
                    self.output.castInfo.value = value.cast
                }
            case .failure(let error) :
                dump(error)
            }
        }
    }
}
