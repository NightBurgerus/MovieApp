//
//  FilmModels.swift
//  MovieApp
//
//  Created by Чебупелина on 02.08.2023.
//

import Foundation

protocol FilmsProtocol: Decodable {
    associatedtype T
    var data: [T] { get }
}

protocol FilmModelProtocol: Decodable {
    var nameRu: String? { get set }
    var nameEn: String? { get set }
    var posterUrl: String? { get set }
    var posterUrlPreview: String? { get set }
    var year: Int { get set }
}

struct RandomFilmResponse: FilmsProtocol {
    typealias T = RandomFilm
    
    let total: Int
    let totalPages: Int
    let data: [T]
    
    enum CodingKeys: String, CodingKey {
        case total, totalPages
        case data = "items"
    }
}

struct RandomFilm: FilmModelProtocol {
    let kinopoiskId: Int
    let imdbId: String?
    var nameRu: String?
    var nameEn: String?
    let nameOriginal: String?
    let countries: [[String: String]]
    let genres: [[String: String]]
    let ratingKinopoisk: Double
    let ratingImdb: Double?
    var year: Int
    let type: String
    var posterUrl: String?
    var posterUrlPreview: String?
    
    enum CodingKeys: String, CodingKey {
        case kinopoiskId, imdbId, nameRu, nameEn, nameOriginal
        case countries, genres, ratingKinopoisk, ratingImdb
        case year, type, posterUrl
        case posterUrlPreview = "posterURLPreview"
    }
}

struct LastReleasesResponse: FilmsProtocol {
    typealias T = LastReleaseFilm
    let page: Int?
    let total: Int
    let data: [T]
    
    enum CodingKeys: String, CodingKey {
        case page, total
        case data = "items"
    }
}

struct LastReleaseFilm: FilmModelProtocol {
    let kinopoiskId: Int
    var nameRu: String?
    var nameEn: String?
    var year: Int
    var posterUrl: String?
    var posterUrlPreview: String?
    let countries: [[String: String]]
    let genres: [[String: String]]
    let rating: Double?
    let ratingVoteCount: Int?
    let expectationsRating: Double?
    let expectationsRatingVoteCount: Int?
    let duration: Int?
    let releaseDate: String?
}

struct TopFilmsResponse: FilmsProtocol {
    typealias T = TopFilm
    let pageCount: Int?
    let data: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageCount
        case data = "films"
    }
}

struct TopFilm: FilmModelProtocol {
    let filmId: Int
    var nameRu: String?
    var nameEn: String?
    var year: Int
    let filmLength: String?
    let countries: [[String: String]]
    let genres: [[String: String]]
    let rating: String
    let ratingVoteCount: Int
    var posterUrl: String?
    var posterUrlPreview: String?
    let ratingChange: Int?
    let isRatingUp: Bool?
    let isAfisha: Int
}

extension TopFilm {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case filmId
        case nameRu
        case nameEn
        case year
        case filmLength
        case countries
        case genres
        case rating
        case ratingVoteCount
        case posterUrl
        case posterUrlPreview
        case ratingChange
        case isRatingUp
        case isAfisha
    }
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.filmId = (try? container.decode(Int.self, forKey: .filmId)) ?? 0
            self.nameRu = try? container.decode(String.self, forKey: .nameRu)
            self.nameEn = try? container.decode(String.self, forKey: .nameEn)
            
            self.year = Int((try? container.decode(String.self, forKey: .year)) ?? "2023") ?? 0
            self.filmLength = try? container.decode(String.self, forKey: .filmLength)
            self.countries = (try? container.decode([[String: String]].self, forKey: .countries)) ?? [[:]]
            self.genres = (try? container.decode([[String: String]].self, forKey: .genres)) ?? [[:]]
            self.rating = (try? container.decode(String.self, forKey: .rating)) ?? ""
            self.ratingVoteCount = (try? container.decode(Int.self, forKey: .ratingVoteCount)) ?? 0
            self.posterUrl = try? container.decode(String.self, forKey: .posterUrl)
            self.posterUrlPreview = try? container.decode(String.self, forKey: .posterUrlPreview)
            self.ratingChange = try? container.decode(Int.self, forKey: .ratingChange)
            self.isRatingUp = try? container.decode(Bool.self, forKey: .isRatingUp)
            self.isAfisha = (try? container.decode(Int.self, forKey: .isAfisha)) ?? 0
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: CodingKeys.allCases, debugDescription: ""))
    }
}
