//
//  KinopoiskFilmsModel.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import Foundation

// TMDB api not availeble from ru zone
// I wanna use https://kinopoiskapiunofficial.tech/ api

// MARK: - Model for MainViewController
struct KinopoiskFilmsArrayModel: Codable {
    var total, totalPages: Int
    var items: [FilmItem]
}

struct FilmItem: Codable {
    var kinopoiskId: Int
    var nameRu: String
    var ratingKinopoisk: Double
    var year: Int
    var posterUrlPreview: String
}

// MARK: - Model for DeteilFilmViewController
// MARK: - KinopoiskFilmDeteilModel
struct KinopoiskFilmDeteilModel: Codable {
    var kinopoiskId: Int = 0
    var nameRu: String = ""
    var nameOriginal: String = ""
    var posterUrl = ""
    var posterUrlPreview: String = ""
    //var coverURL: String
    var ratingKinopoisk: Double = 0.0
    var ratingImdb: Double = 0.0
    //var webUrl: String
    var year = 0
    var filmLength: Int = 0
    var description: String = ""
    var countries: [Country]
    var genres: [Genre]
}

// MARK: - Country
struct Country: Codable {
    var country: String = ""
}

// MARK: - Genre
struct Genre: Codable {
    var genre: String = ""
}


// MARK: - Model for FilmPicsViewController
// MARK: - KinopoiskFilmImagesModel
struct KinopoiskFilmImagesModel: Codable {
    var total, totalPages: Int
    var items: [ImageItem]
}

struct ImageItem: Codable {
    var imageUrl, previewUrl: String
}



// MARK: - KinopoiskSearchedFilm
struct KinopoiskSearchedFilm: Codable {
    var keyword: String
    var pagesCount: Int
    var films: [SearchedFilms]
    var searchFilmsCountResult: Int
}

// MARK: - SearchedFilms
struct SearchedFilms: Codable {
    var filmId: Int
    var nameRu: String
    var year: String
    var rating: String
    var posterUrlPreview: String
}


// MARK: - KinopoiskPremiereFilms
struct KinopoiskPremiereFilms: Codable {
    var total: Int
    var items: [PremiereFilm]
}

// MARK: - Item
struct PremiereFilm: Codable {
    var kinopoiskId: Int
    var nameRu: String
    var year: Int
    var posterUrlPreview: String
    var duration: Int?
    var premiereRu: String
}


// MARK: - KinopoiskReleaseFilms
struct KinopoiskReleaseFilms: Codable {
    var releases: [Release]
    var page, total: Int
}

// MARK: - Release
struct Release: Codable {
    var filmId: Int
    var nameRu: String
    var year: Int
    var posterUrlPreview: String
    var rating: Double?
    var releaseDate: String
}
