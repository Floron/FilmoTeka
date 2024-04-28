//
//  FilmModel.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 28.04.2024.
//

import Foundation

//      1. Запуск приложения
//      2. Загружается массив фильмов с ресурса
//      3. Массив фильмов приводится к общему типу данных
//      4. Производится анализ на наличие фильма в базе любимых фильмов
//      5. Отображение на экране

class FilmModel {
    let network = NetworkModel()

    let realm = RealmService.shared
    
    var filmsArray: [ModelForCollectionView] = []
    
    func isFilmInFavorite(id: Int) -> Bool {
        realm.updateLikedFilmsArray()
        for film in realm.likedFilmsArray {
            if film.kinopoiskId == id {
                return true
            }
        }
        return false
    }
    
    func addOrRemoveFilmToFavorite(film: ModelForCollectionView) {
        if film.isLiked {
            print("\(film.nameRu)  was deleted")
            
            for item in filmsArray {
                if item.kinopoiskId == film.kinopoiskId {
                    item.isLiked = false
                }
            }
            
            realm.deleteFilm(film)

        } else {
            print("\(film.nameRu) liked now!!!!")
            realm.create(film)
        }
    }
    
    func sorting(method: String, isMore: Bool, whatToSort: Bool = false) {    
        if whatToSort {
            realm.likedFilmsArray = realm.likedFilmsArray.sorted(byKeyPath: method, ascending: isMore)
        } else {
            filmsArray = (filmsArray as NSArray).sortedArray(using: [NSSortDescriptor(key: method, ascending: isMore)]) as! [ModelForCollectionView]
        }
    }
}
