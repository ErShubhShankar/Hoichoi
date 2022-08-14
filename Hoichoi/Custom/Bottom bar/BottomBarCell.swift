//
//  BottomBarCell.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 13/08/22.
//

import UIKit

class BottomBarCell: UICollectionViewCell {

    @IBOutlet weak var imageTabIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    private var tabItem: TabItem?

    override var isSelected: Bool {
        didSet {
            setSelected(selection: isSelected)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageTabIcon.tintColor = UIColor(named: "light_blue_grey")
        labelTitle.textColor = UIColor(named: "light_blue_grey")
    }

    func updateUI(tabItem: TabItem) {
        self.tabItem = tabItem
        labelTitle.text = tabItem.name
        imageTabIcon.image = UIImage(systemName: tabItem.imageName)
        imageTabIcon.tintColor = UIColor(named: "light_blue_grey")
        labelTitle.textColor = UIColor(named: "light_blue_grey")
    }

    func setSelected(selection: Bool) {
      if let tabbar = tabItem {
        if selection {
            imageTabIcon.image = UIImage(systemName: tabbar.selectedImageName)
            imageTabIcon.contentMode = .center
            imageTabIcon.tintColor = UIColor(named: "cherry_red")
            labelTitle.textColor = UIColor(named: "h_white")
        } else {
            imageTabIcon.image = UIImage(systemName: tabbar.imageName)
            imageTabIcon.contentMode = .center
            imageTabIcon.tintColor = UIColor(named: "light_blue_grey")
            labelTitle.textColor = UIColor(named: "light_blue_grey")
        }
      }
    }
}
