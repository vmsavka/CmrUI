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
    
    func updateSelection(isSelected: Bool) {
        //backgroundImageView.setTint(color: isSelected ? CmrTabBarColours.tabBarSelectedItemColor : CmrTabBarColours.tabBarBackgroundColor)
        self.backgroundColor = isSelected ? CmrTabBarColours.tabBarSelectedItemColor : CmrTabBarColours.tabBarBackgroundColor
    }
}
