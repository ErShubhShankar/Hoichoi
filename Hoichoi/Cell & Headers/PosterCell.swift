//
//  PosterCell.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit

class PosterCell: UICollectionViewCell {

    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var imagePlay: UIImageView!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
   
    func updateUI(show: Shows, isTrendingLayout: Bool = false) {
        imagePoster.image = UIImage(named: "placeholder")
        let metaInfo = show.metaInfo
        labelTitle.text = metaInfo.title
        let subtitle = "\(metaInfo.seasons) Seasons • \(metaInfo.episodes) Episodes • \(metaInfo.genre)"
        labelSubtitle.text = subtitle
        let imageURL = show.image
        imagePoster.downloadImage(imageURL: imageURL)
        imagePlay.isHidden = isTrendingLayout
        imageAdd.isHidden = isTrendingLayout
        
        for gradientLayer in viewGradient.layer.sublayers ?? [] where gradientLayer is CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        let posterGradientLayer: CAGradientLayer = CAGradientLayer()
        posterGradientLayer.frame.size = viewGradient.frame.size
        posterGradientLayer.startPoint = CGPoint(x: 1, y: 1)
        posterGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        posterGradientLayer.masksToBounds = true
        posterGradientLayer.colors = [UIColor(named: "dark")!.cgColor, UIColor(named: "dark")!.withAlphaComponent(0).cgColor]
        viewGradient.layer.addSublayer(posterGradientLayer)
    }
}
