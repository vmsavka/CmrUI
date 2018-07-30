//
//  TotalPhotosChartCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/23/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class TotalPhotosChartCell: UICollectionViewCell, ProfileCellView {
    
    func display(title: String) {
        
    }
    
    func display(image: UIImage) {
        
    }
    
    func display(date: Date) {
        
    }
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
}
