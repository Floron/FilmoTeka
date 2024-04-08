//
//  PosterFullViewController.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit
import Kingfisher

class PosterFullViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var fullPosterImageView: UIImageView!
    
    var fullPosterURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fullPosterURL = URL(string: fullPosterURLString) {
            fullPosterImageView.kf.indicatorType = .activity
            fullPosterImageView.kf.setImage(with: fullPosterURL)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
