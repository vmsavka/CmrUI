//
//  DashboardBadgesCell.swift
//  CmrUI
//

import UIKit

class DashboardBadgesCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    func setImage(image: UIImage?) {
        backgroundImageView.image = image
    }
}
