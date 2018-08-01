//
//  SunsetRemainingCell.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/30/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private struct Constants {
    static let topGradientColor = UIColor(red: 245.0/255.0, green: 217.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    static let bottomGradientColor = UIColor(red: 231.0/255.0, green: 116.0/255.0, blue: 55.0/255.0, alpha: 1.0)
}

class SunsetRemainingCell: UICollectionViewCell , ProfileCellView {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var sunsetLogoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        setup()
    }
    
    public func setup() {
        gradientView.addGradient(colors: [Constants.topGradientColor,
                                          Constants.bottomGradientColor],
                                 start: CGPoint(x:0.5, y:0.2),
                                 end: CGPoint(x:0.5, y:1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.frame = frame
        gradientView.updateGradientLayerFrame()
    }
    
    public func displayTime(hoursRemaining: Int) {
        timeLabel.text = "\(hoursRemaining)"
    }
}

extension SunsetRemainingCell {
    func display(title: String) {
        timeDescriptionLabel.text = title
    }
    
    func display(image: UIImage) {
        sunsetLogoImageView.image = image
    }
    
    func display(date: Date) {}
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }
}
