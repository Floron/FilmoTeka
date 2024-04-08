//
//  ViewController.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    let network = NetworkModel()
    var collectionViewTopConstraint: NSLayoutConstraint?
    
    //var testArray: [TestModel] = []
    
//    lazy var searchBar : UISearchBar = {
//        let s = UISearchBar()
//            s.placeholder = "Search Timeline"
//            s.delegate = self
//            s.tintColor = .white
//            s.barTintColor = .blue
//            s.barStyle = .default
//            s.sizeToFit()
//        return s
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self

        searchBar.isHidden = true
        //mainCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionViewTopConstraint = self.mainCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        collectionViewTopConstraint?.isActive = true
        
        
        mainCollectionView.isUserInteractionEnabled = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDownToShowUISearchBar))
        swipeDown.delegate = self
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        mainCollectionView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedDownToShowUISearchBar))
        swipeUp.delegate = self
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        mainCollectionView.addGestureRecognizer(swipeUp)
                
       // testArray = giveMeAnArray()
        
        //let xibCell = UINib(nibName: "FilmCollectionViewCell", bundle: nil)
        //mainCollectionView.register(xibCell, forCellWithReuseIdentifier: "FilmCellXib")
        //mainCollectionView.reloadData()
        
        network.loadData {
            print("Data downloaded")
//            print(self.filmsArray.count)
            self.mainCollectionView.reloadData()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
//    func giveMeAnArray () -> [TestModel] {
//        var myTestArray: [TestModel] = []
//        for i in 1...15 {
//            myTestArray.append(TestModel(testPic: "image\(i)",
//                                         testTitle: "Фильм \(i)",
//                                         testYear: "\(Int.random(in: 2000..<2025))",
//                                         testRating: String(format: "%0.1f", Float.random(in: 5..<10))
//                                        ))
//        }
//        return myTestArray
//    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return network.filmsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "FilmCell", for: indexPath) as? FilmCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.posterPreviewImageView.kf.indicatorType = .activity
        cell.posterPreviewImageView.kf.setImage(with: URL(string: network.filmsArray[indexPath.row].posterUrlPreview))
        cell.filmTitleLabel.text = network.filmsArray[indexPath.row].nameRu
        cell.releaseYearLabel.text = "\(network.filmsArray[indexPath.row].year)"
        if let rating = network.filmsArray[indexPath.row].ratingKinopoisk {
            cell.ratingLabel.text = "\(rating)"
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        network.loadFilmDeteilData(enter: network.filmsArray[indexPath.row].kinopoiskId) { deteilFilmData in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeteilFilmViewController") as? DeteilFilmViewController else { return }
            vc.deteilFilmItem = deteilFilmData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        ////self.present(vc, animated: true)
    }
}


extension MainViewController: UISearchBarDelegate {
    
    @objc func swipedDownToShowUISearchBar(gesture : UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.down:
                searchBar.isHidden = false
                collectionViewTopConstraint?.isActive = false
                collectionViewTopConstraint = mainCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0)
                collectionViewTopConstraint?.isActive = true
                print("User swiped Down")
            case UISwipeGestureRecognizer.Direction.up:
                searchBar.isHidden = true
                collectionViewTopConstraint?.isActive = false
                collectionViewTopConstraint = mainCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
                collectionViewTopConstraint?.isActive = true
                print("User swiped Up")
            default:
                break
            }
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        arrayFlickrPicksURLs.removeAll()
        searchBar.showsCancelButton = false
        searchBar.text = ""

        view.endEditing(true)    // hide keyboard
        
//        self.getJSONFromApi {
//            self.mainCollectionView.reloadData()
//        }
    }
    
    // Shift + Command + K to show keyboard
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        arrayFlickrPicksURLs.removeAll()
        searchBar.showsCancelButton = false
        
        view.endEditing(true)   // hide keyboard
        
//        self.getJSONFromApi(picturesToSearch: searchBar.text) {
//            self.mainCollectionView.reloadData()
//        }
    }
}

