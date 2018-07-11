//
//  CmrBarButtonCell.swift
//  CmrUI
//

import UIKit

class CmrBarButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(image: UIImage) {
        backgroundImageView.image = image
    }
    
    func setSelected(isSelected: Bool) {
        backgroundImageView.setTint(color: isSelected ? CmrTabBarColours.tabBarSelectedItemColor : CmrTabBarColours.tabBarBackgroundColor)
        backgroundColor = isSelected ? CmrTabBarColours.tabBarSelectedItemColor : CmrTabBarColours.tabBarBackgroundColor
    }

}
