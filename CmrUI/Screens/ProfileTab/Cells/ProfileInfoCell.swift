//
//  ProfileInfoCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/30/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class ProfileInfoCell: UICollectionViewCell , ProfileCellView {
    
    @IBOutlet weak var badgesCallectionView: UICollectionView!
    @IBOutlet weak var ellipseView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }

    func setup() {
        ellipseView.backgroundColor = UIColor.magenta
    }
    
}

extension ProfileInfoCell {
    
    func display(title: String) {
        
    }
    
    func display(image: UIImage) {
        
    }
    
    func display(date: Date) {
        
    }
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }
}
