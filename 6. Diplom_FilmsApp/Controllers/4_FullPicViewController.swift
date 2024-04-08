//
//  FullPicViewController.swift
//  6. Diplom_FilmsApp
//
//  Created by Floron on 25.03.2024.
//

import UIKit
import Kingfisher

class FullPicViewController: UIViewController {
    
    @IBOutlet weak var picCountLabel: UILabel!
    @IBOutlet weak var fullFilmPicture: UIImageView!
    
    var currentnImageIndex = 0
    var arrayOfImages = [ImageItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullFilmPicture.kf.indicatorType = .activity
        fullFilmPicture.isUserInteractionEnabled = true//do not forget to right this line otherwise ...imageView's image will not move

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedDone))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        fullFilmPicture.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedDone))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        fullFilmPicture.addGestureRecognizer(swipeLeft)
        
        fullFilmPicture.kf.setImage(with: URL(string: arrayOfImages[currentnImageIndex].imageUrl))
        picCountLabel.text = "\(currentnImageIndex + 1)/\(arrayOfImages.count)"
    }
    
    @objc func swipedDone(gesture : UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                print("User swiped right")
                
                if currentnImageIndex < arrayOfImages.count - 1 {
                    currentnImageIndex += 1
                } else {
                    currentnImageIndex = 0 // возвращаемся на первое фото
                }
                
                fullFilmPicture.kf.setImage(with: URL(string: arrayOfImages[currentnImageIndex].imageUrl))
                picCountLabel.text = "\(currentnImageIndex + 1)/\(arrayOfImages.count)"
            case UISwipeGestureRecognizer.Direction.left:
                print("User swiped left")
                
                if currentnImageIndex > 0{
                    currentnImageIndex -= 1
                } else {
                    currentnImageIndex = arrayOfImages.count - 1
                }
                
                fullFilmPicture.kf.setImage(with: URL(string: arrayOfImages[currentnImageIndex].imageUrl))
                picCountLabel.text = "\(currentnImageIndex + 1)/\(arrayOfImages.count)"
            default:
                break
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
