//
//  HeaderCollectionReusableView.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//
import UIKit

class AccountHeader: UICollectionReusableView {
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonHeader: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = viewGradient.frame.size
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor(named: "cherry")!.cgColor, UIColor(named: "w_blue")!.cgColor]
        viewGradient.layer.addSublayer(gradientLayer)
    }
}
