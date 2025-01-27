//
//  DataModel.swift
//  MovieBox
//
//  Created by marty.academy on 1/27/25.
//

import Foundation

struct TrendingMovie: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let backdropPath: String
    let id: Int
    let title, overview, posterPath: String
    let genreIDS: [Int]
    let releaseDate: String
    let voteAverage: Float

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title, overview
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
