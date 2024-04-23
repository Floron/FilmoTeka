//
//  2.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit
import Kingfisher

class DeteilFilmViewController: UIViewController {
    
    var transition = RoundingTransition()
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var galleryCollection: UICollectionView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var originalFilmTitleLabel: UILabel!
    @IBOutlet weak var filmCountry: UILabel!
    @IBOutlet weak var filmGenres: UILabel!
    @IBOutlet weak var filmDuration: UILabel!
    
    
    @IBOutlet weak var tryButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var onLikePressed: ( () -> () )?
    var deteilFilmItem: KinopoiskFilmDeteilModel!
    var filmPicsArray: [ImageItem] = []
    var isLiked: Bool = false
//    {
//        didSet {
//            isLiked ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        galleryCollection.dataSource = self
        galleryCollection.delegate = self
        
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: URL(string: deteilFilmItem.posterUrl))
        filmTitleLabel.text = deteilFilmItem.nameRu
        originalFilmTitleLabel.text = deteilFilmItem.nameOriginal
        releaseYearLabel.text = "\(deteilFilmItem.year)"
        ratingLabel.text = "\(deteilFilmItem.ratingKinopoisk)"
        filmDuration.text = "\(deteilFilmItem.filmLength) минут"
        descriptionTextView.text = deteilFilmItem.description
        
        var countries = deteilFilmItem.countries[0].country
        if deteilFilmItem.countries.count > 1 {
            for index in 1 ..< deteilFilmItem.countries.count {
                countries = countries + ", " + deteilFilmItem.countries[index].country
            }
        }
        var genres = deteilFilmItem.genres[0].genre
        if deteilFilmItem.genres.count > 1 {
            for index in 1 ..< deteilFilmItem.genres.count {
                genres = genres + ", " + deteilFilmItem.genres[index].genre
            }
        }
        filmCountry.text = countries
        filmGenres.text = genres
        
        isLiked ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
       
    @IBAction func likeButtonPressed(_ sender: Any) {
        isLiked.toggle()
        isLiked ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        onLikePressed?()
    }
}

extension DeteilFilmViewController: UIViewControllerTransitioningDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let fullPosterVC = segue.destination as? PosterFullViewController else { return }
        fullPosterVC.fullPosterURLString = deteilFilmItem.posterUrl
        
        fullPosterVC.transitioningDelegate = self
        fullPosterVC.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition.transitionProfile = .show
        transition.start = posterImageView.center
        //transition.roundColor = UIColor.lightGray
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        transition.transitionProfile = .cancel
        transition.start = posterImageView.center
        transition.roundColor = UIColor.darkGray
        
        return transition
    }
}


extension DeteilFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmPicsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "FilmPics", for: indexPath) as? FilmPicsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.filmPicture.kf.indicatorType = .activity
        cell.filmPicture.kf.setImage(with: URL(string: filmPicsArray[indexPath.row].previewUrl))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullPicVC") as? FullPicViewController else { return }
        vc.currentnImageIndex = indexPath.row
        vc.arrayOfImages = filmPicsArray
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
    }
    
}
