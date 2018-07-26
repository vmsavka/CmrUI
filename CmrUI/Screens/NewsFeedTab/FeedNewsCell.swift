//
//  FeedNewsCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/25/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class FeedNewsCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 15
        self.containerView.clipsToBounds = true
        self.selectionStyle = .none
    }
}
