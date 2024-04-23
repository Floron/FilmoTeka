//
//  mainCollectionViewDataSource.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 11.04.2024.
//

import UIKit

class universalCollectionViewDataSource<Model, CellClass>: NSObject, UICollectionViewDataSource{
    typealias CellConfigurator = (Model, CellClass) -> ()
    var filmArrayToShowInCollectionView: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(filmArrayToShowInCollectionView: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.filmArrayToShowInCollectionView = filmArrayToShowInCollectionView
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmArrayToShowInCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = filmArrayToShowInCollectionView[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CellClass else {
            return UICollectionViewCell()
        }
        
        cellConfigurator(model, cell)

        return cell as! UICollectionViewCell
    }
}



extension universalCollectionViewDataSource where Model == ModelForCollectionView, CellClass == FilmCollectionViewCell {
    static func make(for films: [ModelForCollectionView], reuseIdentifier: String = "FilmCell", filmModel: FilmModel) -> universalCollectionViewDataSource {
        return universalCollectionViewDataSource(filmArrayToShowInCollectionView: films,
                                            reuseIdentifier: reuseIdentifier) { (film, cell) in
            
            cell.film = film

            cell.yourobj = {
                film.isLiked.toggle()
                filmModel.addOrRemoveFilmToFavorite(film: film)
            }
        }
    }
}


