//
//  BackgroundCollectionReusableView.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//


import UIKit

class BackgroundCollectionReusableView: UICollectionReusableView {
        
    let imageIcon = UIImageView(image: UIImage(named: "hoichoi icon"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 12
        self.backgroundColor = UIColor(named: "dark_grey")
        addSubview(imageIcon)
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: imageIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70)
        NSLayoutConstraint.activate([widthConstraint])
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                           toItem: imageIcon, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                           toItem: imageIcon, attribute: .top, multiplier: 1.0, constant: 100).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                           toItem: imageIcon, attribute: .bottom, multiplier: 1.0, constant: 55).isActive = true
        imageIcon.tintColor = UIColor(named: "very_light_pink")
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.alpha = 0.1
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
