//
//  FeedNewsCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/15/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class FeedNewsCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

}
