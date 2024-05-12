//
//  ModelRealm.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 20.04.2024.
//

import Foundation
import RealmSwift

class RealmService {
 
    private init(){}
     
    static let shared = RealmService()
    var rm = try! Realm()
    var likedFilmsArray: Results<ModelForCollectionView>!
    
    func updateLikedFilmsArray() {
        self.likedFilmsArray = rm.objects(ModelForCollectionView.self)
    }
    
    func printRealmBDpath() {
        print("============   Realm file    ==============")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func create(_ object: ModelForCollectionView) {
        do{
            try rm.write{
                object.isLiked = true
                rm.create(ModelForCollectionView.self, value: object)
                //rm.add(object)
                updateLikedFilmsArray()
            }
        } catch {
            print("Cant create: \(error.localizedDescription)")
        }
    }
    
    func deleteFilm(_ object: ModelForCollectionView) {
        do {
            try rm.write {
                //object.isLiked = false
                rm.delete(rm.objects(ModelForCollectionView.self).filter("kinopoiskId=%@",object.kinopoiskId))
                updateLikedFilmsArray()
            }
        } catch {
            print("Cant delete: \(error.localizedDescription)")
        }
    }
   
    
//    func isFilmInFavorite(id: Int) -> Bool {
//       // let realm = RealmService.shared.rm
//       // likedFilmsArray = realm.objects(ModelForCollectionView.self)
//        for film in likedFilmsArray {
//            if film.kinopoiskId == id {
//                return true
//            }
//        }
//        return false
//    }
    
    
    /*
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
    */
}
