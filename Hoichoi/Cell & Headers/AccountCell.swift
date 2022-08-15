//
//  AccountCell.swift
//  Hoichoi
//
//  Created by Shubham Joshi on 14/08/22.
//

import UIKit

class AccountCell: UICollectionViewCell {
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
   
    func updateUI(accountData: AccountData) {
        labelTitle.text = accountData.title
        if let subtitle = accountData.subtitle {
            labelSubtitle.isHidden = false
            labelSubtitle.text = subtitle
        } else {
            labelSubtitle.isHidden = true
        }
    }
}
