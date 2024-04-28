//
//  ViewController.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var showLikedFilmsButton: UIButton!
    
    var filmModel = FilmModel()
    var searchController = UISearchController()
    
    var isShowLikedFilmsButtonPressed = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Введите название фильма/сериала"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        setupSortButton()
        
        filmModel.network.downloader(apiToUse: .defaultUrl) { (model: KinopoiskFilmsArrayModel) in
            for film in model.items {
                let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.kinopoiskId)
                //isFilmInFavorite(id: film.kinopoiskId)
                self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.kinopoiskId,
                                                              nameRu: film.nameRu,
                                                              ratingKinopoisk: film.ratingKinopoisk,
                                                              year: film.year,
                                                              posterUrlPreview: film.posterUrlPreview,
                                                              isLiked: isLikedFilm))
            }
            DispatchQueue.main.async {
                print("Data downloaded")
                self.mainCollectionView.reloadData()
            }
        }
        
        filmModel.realm.printRealmBDpath()
    }

    func setupSortButton() {
        let menuClosure = {(action: UIAction) in
            if let discoverabilityTitle = action.discoverabilityTitle {
                self.update(sortMethod: discoverabilityTitle)
            }
        }
        
        let subMenu = UIMenu(options: .displayInline, preferredElementSize: .medium, children: [
            UIAction(title: "Год", image: UIImage(systemName: "arrow.down"), discoverabilityTitle: "yearDown", handler: menuClosure),
            UIAction(title: "Год", image: UIImage(systemName: "arrow.up"), discoverabilityTitle: "yearUp", handler: menuClosure)
        ])
        sortButton.menu = UIMenu(title: "Сортировка", preferredElementSize: .medium, children: [
            UIAction(title: "Рейтинг", image: UIImage(systemName: "arrow.down"),discoverabilityTitle: "ratingDown", handler: menuClosure),
            UIAction(title: "Рейтинг", image: UIImage(systemName: "arrow.up"), discoverabilityTitle: "ratingUp", handler: menuClosure),
            subMenu
        ])
        sortButton.showsMenuAsPrimaryAction = true
        //sortButton.changesSelectionAsPrimaryAction = true
    }
    
    func update(sortMethod: String) {
        switch sortMethod {
            case "ratingDown":
                filmModel.sorting(method: "ratingKinopoisk", isMore: false, whatToSort: isShowLikedFilmsButtonPressed)
                print("Рейтинг. По убыванию")
            case "ratingUp":
                filmModel.sorting(method: "ratingKinopoisk", isMore: true, whatToSort: isShowLikedFilmsButtonPressed)
                print("Рейтинг. По возрастанию")
            case "yearDown":
                filmModel.sorting(method: "year", isMore: false, whatToSort: isShowLikedFilmsButtonPressed)
                print("Год. По убыванию")
            case "yearUp":
                filmModel.sorting(method: "year", isMore: true, whatToSort: isShowLikedFilmsButtonPressed)
                print("Год. По возрастанию")
            default:
                print("Error")
        }
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
    
    @IBAction func showLikedFilmsButtonPressed(_ sender: UIButton) {
        isShowLikedFilmsButtonPressed.toggle()
        if isShowLikedFilmsButtonPressed {
            print("Showed liked films")
            showLikedFilmsButton.setImage(UIImage(systemName: "bolt.heart.fill"), for: .normal)
        } else {
            print("Showed all films")
            showLikedFilmsButton.setImage(UIImage(systemName: "bolt.heart"), for: .normal)
        }
 
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowLikedFilmsButtonPressed ? filmModel.realm.likedFilmsArray.count : filmModel.filmsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = isShowLikedFilmsButtonPressed ? filmModel.realm.likedFilmsArray[indexPath.row] : filmModel.filmsArray[indexPath.row]
        cell.film = item

        cell.yourobj = {
            //item.isLiked.toggle()
            self.filmModel.addOrRemoveFilmToFavorite(film: item)
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let item = self.isShowLikedFilmsButtonPressed ? self.filmModel.realm.likedFilmsArray[indexPath.row] : self.filmModel.filmsArray[indexPath.row]

            self.filmModel.network.loadFilmDeteilDataAndImages(kinopoiskID: item.kinopoiskId) { deteilFilmData, imagesArray in
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeteilFilmViewController") as? DeteilFilmViewController else { return }
                vc.deteilFilmItem = deteilFilmData
                vc.filmPicsArray = imagesArray
                print(item.isLiked)
                vc.isLiked = item.isLiked
                
            
                vc.onLikePressed = {
                    //item.isLiked.toggle()
                    item.isLiked ? print("Like pressed in DeteilFilmViewController") : print("Dislike pressed in DeteilFilmViewController")
                    self.filmModel.addOrRemoveFilmToFavorite(film: item)
                    DispatchQueue.main.async {
                        self.mainCollectionView.reloadData()
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension MainViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""

        view.endEditing(true)    // hide keyboard
    }
    
    // Shift + Command + K to show keyboard
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = false
        
        view.endEditing(true)   // hide keyboard
        
        guard let searchText = searchBar.text else { return }
        
        filmModel.network.downloader(apiToUse: .searchFilm, keyword: searchText) { (foundFilmsArray: KinopoiskSearchedFilm) in
            self.filmModel.filmsArray.removeAll()
            
            for film in foundFilmsArray.films {
                let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.filmId)
               // isFilmInFavorite(id: film.filmId)

                self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.filmId,
                                                                        nameRu: film.nameRu,
                                                                        ratingKinopoisk: Double(film.rating) ?? 0.0,
                                                                        year: Int(film.year) ?? 0,
                                                                        posterUrlPreview: film.posterUrlPreview,
                                                                        isLiked: isLikedFilm))
            }
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }
}
