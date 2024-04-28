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
