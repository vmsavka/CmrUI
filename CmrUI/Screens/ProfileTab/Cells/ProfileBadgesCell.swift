//
//  ProfileBadgesCell.swift
//  CmrUI
//

import UIKit

class ProfileBadgesCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    func setImage(image: UIImage?) {
        backgroundImageView.image = image
    }
}
