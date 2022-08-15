//
//  ShowsCell.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit

class ShowsCell: UICollectionViewCell {

    @IBOutlet weak private var viewBadge: UIView!
    @IBOutlet weak private var viewSeekBar: UIView!
    @IBOutlet weak private var imagePoster: UIImageView!
    @IBOutlet weak private var labelTitle: UILabel!
    @IBOutlet weak private var viewTitle: UIView!
    
    func updateTitleUI(show: Shows, hideBadge: Bool = true) {
        imagePoster.image = UIImage(named: "placeholder")
        viewBadge.isHidden = hideBadge
        let metaInfo = show.metaInfo
        labelTitle.text = metaInfo.title
        let imageURL = show.image
        imagePoster.downloadImage(imageURL: imageURL)
        if var percentage = show.completionPercentage {
            percentage = percentage > 100.0 ? 100 : percentage
            viewSeekBar.isHidden = false
            setSeek(percentage: percentage)
        } else {
            viewSeekBar.isHidden = true
        }
        
    }
    
    private func setSeek(percentage: Double) {
        let totalWidth = frame.width
        let newWidth = totalWidth*percentage/100
        if let constraint = viewSeekBar.constraints.filter({$0.firstAttribute == .width}).first {
            UIView.animate(withDuration: 0.5, delay: 3.0, animations: {
                constraint.constant = newWidth
            })
        }
    }
}
