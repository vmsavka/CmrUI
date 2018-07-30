//
//  BatteryRemainingCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/23/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class BatteryRemainingCell: UICollectionViewCell, ProfileCellView {
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
        // Initialization code
    }
    
//    @IBOutlet weak var bookTitleLabel: UILabel!
//    @IBOutlet weak var bookAuthorLabel: UILabel!
//    @IBOutlet weak var bookReleaseDateLabel: UILabel!
//    
//    
//    func display(title: String) {
//        bookTitleLabel.text = title
//    }
//    
//    func display(author: String) {
//        bookAuthorLabel.text = author
//    }
//    
//    func display(releaseDate: String) {
//        bookReleaseDateLabel.text = releaseDate
//    }

}
