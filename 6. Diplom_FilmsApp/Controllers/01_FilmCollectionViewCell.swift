//
//  FilmCollectionViewCell.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit
import Kingfisher

class FilmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterPreviewImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var filmTitleLabel: UILabel!
    
    @IBOutlet weak var likeButtonInCell: UIButton!
    
    var yourobj: (() -> ())? = nil
    
    var film: ModelForCollectionView! {
        didSet {
            posterPreviewImageView.kf.indicatorType = .activity
            posterPreviewImageView.kf.setImage(with: URL(string: film.posterUrlPreview))
            filmTitleLabel.text = film.nameRu
            releaseYearLabel.text = "\(film.year)"
            ratingLabel.text = "\(film.ratingKinopoisk)"
            
            film.isLiked ? likeButtonInCell.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButtonInCell.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func btnAction(sender: UIButton) {
        if let btnAction = self.yourobj {
            btnAction()
        }
    }
}
