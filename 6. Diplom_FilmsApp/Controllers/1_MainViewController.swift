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
    @IBOutlet weak var collectionChooeserButton: UIButton!
    @IBOutlet weak var showLikedFilmsButton: UIButton!
    
    var filmModel = FilmModel()
    var searchController = UISearchController()

    var isShowLikedFilmsButtonPressed = false {
        didSet {
            isShowLikedFilmsButtonPressed ? showLikedFilmsButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : showLikedFilmsButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Введите название фильма/сериала"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        setupRightBarButtons()
        
        update(sortMethod: "TOP_250_MOVIES")
        
        filmModel.realm.printRealmBDpath()
    }
    
    func setupRightBarButtons() {
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
        
        let subsubMenu = UIMenu(options: .displayInline, preferredElementSize: .medium, children: [
            UIAction(title: "Премьеры", discoverabilityTitle: "Premiers", handler: menuClosure),
            UIAction(title: "Цифровые релизы", discoverabilityTitle: "Releases", handler: menuClosure)
        ])
        collectionChooeserButton.menu = UIMenu(title: "Показать:", preferredElementSize: .medium, children: [
            UIAction(title: "TOP 250 Фильмов", discoverabilityTitle: "TOP_250_MOVIES", handler: menuClosure),
            UIAction(title: "TOP 250 Сериалов", discoverabilityTitle: "TOP_250_TV_SHOWS", handler: menuClosure),
            subsubMenu
        ])
        collectionChooeserButton.showsMenuAsPrimaryAction = true
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
            case "TOP_250_MOVIES":
                isShowLikedFilmsButtonPressed = false
            
                print("Вывожу на экран TOP_250_MOVIES")
                filmModel.filmsArray.removeAll()
                filmModel.network.downloader(apiToUse: .defaultUrl) { (model: KinopoiskFilmsArrayModel) in
                    DispatchQueue.main.async {
                        for film in model.items {
                            let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.kinopoiskId)
                            
                            self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.kinopoiskId,
                                                                                    nameRu: film.nameRu,
                                                                                    ratingKinopoisk: "\(film.ratingKinopoisk)",
                                                                                    year: "\(film.year)",
                                                                                    posterUrlPreview: film.posterUrlPreview,
                                                                                    isLiked: isLikedFilm))
                        }
                        
                        print("Data downloaded")
                        self.mainCollectionView.reloadData()
                    }
                }
            case "Premiers":
                isShowLikedFilmsButtonPressed = false
            
                print("Вывожу на экран Premiers")
                filmModel.filmsArray.removeAll()
                filmModel.network.downloader(apiToUse: .premiere) { (model: KinopoiskPremiereFilms) in
                    
                    DispatchQueue.main.async {
                        for film in model.items {
                            let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.kinopoiskId)
                            
                            self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.kinopoiskId,
                                                                                    nameRu: film.nameRu,
                                                                                    ratingKinopoisk: film.premiereRu,
                                                                                    year: "\(film.year)",
                                                                                    posterUrlPreview: film.posterUrlPreview,
                                                                                    isLiked: isLikedFilm))
                        }
                        
                        print("Premiers downloaded")
                        self.mainCollectionView.reloadData()
                    }
                    
                }
            case "TOP_250_TV_SHOWS":
                isShowLikedFilmsButtonPressed = false
  
                print("Вывожу на экран TOP_250_TV_SHOWS")
                filmModel.filmsArray.removeAll()
                filmModel.network.downloader(apiToUse: .topTVshows) { (model: KinopoiskFilmsArrayModel) in
                    DispatchQueue.main.async {
                        for film in model.items {
                            let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.kinopoiskId)
                            
                            self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.kinopoiskId,
                                                                                    nameRu: film.nameRu,
                                                                                    ratingKinopoisk: "\(film.ratingKinopoisk)",
                                                                                    year: "\(film.year)",
                                                                                    posterUrlPreview: film.posterUrlPreview,
                                                                                    isLiked: isLikedFilm))
                        }
                        
                        print("TopTVshows downloaded")
                        self.mainCollectionView.reloadData()
                    }
                }
            case "Releases":
                isShowLikedFilmsButtonPressed = false
            
                print("Вывожу на экран Releases")
                filmModel.filmsArray.removeAll()
                filmModel.network.downloader(apiToUse: .releases) { (model: KinopoiskReleaseFilms) in
                    
                    DispatchQueue.main.async {
                        for film in model.releases {
                            let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.filmId)
                            
                            self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.filmId,
                                                                                    nameRu: film.nameRu,
                                                                                    ratingKinopoisk: String(format: "%.01f",film.rating ?? 0.0),
                                                                                    year: film.releaseDate,
                                                                                    posterUrlPreview: film.posterUrlPreview,
                                                                                    isLiked: isLikedFilm))
                        }
                    
                        print("Premiers downloaded")
                        self.mainCollectionView.reloadData()
                    }
                    
                }
            default:
                print("Error")
        }
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
    
    @IBAction func showLikedFilmsButtonPressed(_ sender: UIButton) {
        isShowLikedFilmsButtonPressed.toggle()
//        if isShowLikedFilmsButtonPressed {
//            print("Showed liked films")
//            showLikedFilmsButton.setImage(UIImage(systemName: "bolt.heart.fill"), for: .normal)
//        } else {
//            print("Showed all films")
//            showLikedFilmsButton.setImage(UIImage(systemName: "bolt.heart"), for: .normal)
//        }
 
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""

        view.endEditing(true)    // hide keyboard
    }
    
    // Shift + Command + K to show keyboard
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)   // hide keyboard
        
        guard let searchText = searchBar.text else { return }
       
        filmModel.network.downloader(apiToUse: .searchFilm, keyword: searchText) { (foundFilmsArray: KinopoiskSearchedFilm) in
            self.filmModel.filmsArray.removeAll()
            
            DispatchQueue.main.async {
                for film in foundFilmsArray.films {
                    let isLikedFilm = self.filmModel.isFilmInFavorite(id: film.filmId)

                    self.filmModel.filmsArray.append(ModelForCollectionView(kinopoiskId: film.filmId,
                                                                            nameRu: film.nameRu,
                                                                            ratingKinopoisk: film.rating,
                                                                            year: film.year,
                                                                            posterUrlPreview: film.posterUrlPreview,
                                                                            isLiked: isLikedFilm))
                }
            
                //DispatchQueue.main.async {      // с Alamofire все работало
                self.mainCollectionView.reloadData()
            }
        }
    }
}
