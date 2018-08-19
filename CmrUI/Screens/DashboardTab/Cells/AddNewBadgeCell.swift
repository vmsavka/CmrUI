//
//  AddNewBadgeCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 8/14/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class AddNewBadgeCell: UITableViewCell {
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeTitleLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var topSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(title: String) {
        badgeTitleLabel.text = title
    }
    
    func setImage(image: UIImage) {
        badgeImageView.image = image
    }
    
    func setNumber(number: Int) {
        serialNumberLabel.text = "\(number)."
    }
    
    func showTopSeparatorView() {
        topSeparatorView.isHidden = false
    }
}
