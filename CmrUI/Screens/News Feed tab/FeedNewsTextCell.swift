//
//  FeedNewsTextCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/15/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private let feedNewsTextCellColor = UIColor(red: 226.0/255.0, green: 229.0/255.0, blue: 232.0/255.0, alpha: 1.0)

class FeedNewsTextCell: UICollectionViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.backgroundColor = feedNewsTextCellColor
    }

}
