//
//  ModelForCollectionView.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 11.04.2024.
//

import Foundation
import RealmSwift

class ModelForCollectionView: Object {
    @objc dynamic var kinopoiskId: Int = 0
    @objc dynamic var nameRu: String = ""
    @objc dynamic var ratingKinopoisk: Double = 0.0
    @objc dynamic var year: Int = 2000
    @objc dynamic var posterUrlPreview: String = ""
    @objc dynamic var isLiked: Bool = false
    
    override static func primaryKey() -> String? {
        return "kinopoiskId"
    }
    
    convenience init(kinopoiskId: Int, nameRu: String, ratingKinopoisk: Double, year: Int, posterUrlPreview: String, isLiked: Bool) {
        self.init()
        
        self.kinopoiskId = kinopoiskId
        self.nameRu = nameRu
        self.ratingKinopoisk = ratingKinopoisk
        self.year = year
        self.posterUrlPreview = posterUrlPreview
        self.isLiked = isLiked
    }
}

//      1. Запуск приложения
//      2. Загружается массив фильмов с ресурса
//      3. Массив фильмов приводится к общему типу данных
//      4. Производится анализ на наличие фильма в базе любимых фильмов
//      5. Отображение на экране

class FilmModel {
    let network = NetworkModel()
    
    var filmsArray: [ModelForCollectionView] = []
    
    var likedFilmsArray: [ModelForCollectionView] = [
        ModelForCollectionView(kinopoiskId: 435, nameRu: "Зеленая миля", ratingKinopoisk: 9.1, year: 1999, posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/435.jpg", isLiked: true),
        ModelForCollectionView(kinopoiskId: 535341, nameRu: "1+1", ratingKinopoisk: 8.8, year: 2011, posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/535341.jpg", isLiked: true),
        ModelForCollectionView(kinopoiskId: 3498, nameRu: "Властелин колец: Возвращение короля", ratingKinopoisk: 8.7, year: 2003, posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/3498.jpg", isLiked: true),
        ModelForCollectionView(kinopoiskId: 328, nameRu: "Властелин колец: Братство Кольца", ratingKinopoisk: 8.6, year: 2001, posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/328.jpg", isLiked: true),
        ModelForCollectionView(kinopoiskId: 843650, nameRu: "Мстители: Финал", ratingKinopoisk: 7.9, year: 2019, posterUrlPreview: "https://kinopoiskapiunofficial.tech/images/posters/kp_small/843650.jpg", isLiked: true)
    ]
   // var sortedFilmsArray: [ModelForCollectionView] = []
    
    func isFilmInFavorite(id: Int) -> Bool {
        for film in likedFilmsArray {
            if film.kinopoiskId == id {
                return true
            }
        }
        return false
    }
    
    func addOrRemoveFilmToFavorite(film: ModelForCollectionView) {
        if film.isLiked {
            likedFilmsArray.append(film)
        } else {
            if let index = likedFilmsArray.firstIndex(where: { $0.kinopoiskId == film.kinopoiskId }) {
                print("\(film.nameRu) is unliked now!!!!")
                likedFilmsArray.remove(at: index)
            }
            for item in filmsArray {
                if item.kinopoiskId == film.kinopoiskId {
                    item.isLiked = false
                }
            }
        }
    }
    
    
//    func showLikedItems() -> [ModelForCollectionView] {
//        for film in filmsArray {
//            if film.isLiked {
//                likedFilmsArray.append(film)
//            }
//        }
//        return likedFilmsArray
//    }
    
    
    func sorting(method: String, isMore boolType: Bool, whatToSort: Bool = false) {
        if method == "raiting" {
            if whatToSort {
                likedFilmsArray.sort {
                    boolType ? $0.ratingKinopoisk > $1.ratingKinopoisk : $0.ratingKinopoisk < $1.ratingKinopoisk
                }
            } else {
                filmsArray.sort {
                    boolType ? $0.ratingKinopoisk > $1.ratingKinopoisk : $0.ratingKinopoisk < $1.ratingKinopoisk
                }
            }
        }
        
        if method == "year" {
            if whatToSort {
                likedFilmsArray.sort {
                    boolType ? $0.year > $1.year : $0.year < $1.year
                }
            } else {
                filmsArray.sort {
                    boolType ? $0.year > $1.year : $0.year < $1.year
                }
            }
        }
    }
}
