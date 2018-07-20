//
//  DevicePropertiesView.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/19/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

typealias CheckForUpgradeCallback = (() -> Void)

class DevicePropertiesView: UIView {
    
    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var deviceIDValueLabel: UILabel!
    @IBOutlet weak var macAddressLabel: UILabel!
    @IBOutlet weak var macAddressValueLabel: UILabel!
    @IBOutlet weak var firmwareVersionLabel: UILabel!
    @IBOutlet weak var firmwareVersionValueLabel: UILabel!
    @IBOutlet weak var checkForUpgradeButton: UIButton!
    
    var checkForUpgradecallback: CheckForUpgradeCallback?

    @IBAction func checkForUpgradePressed() {
        checkForUpgradecallback?()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black,
                          NSAttributedStringKey.font:  UIFont(name: "HelveticaNeue-Medium", size: 13.0) ?? 15,
                          NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        checkForUpgradeButton?.setAttributedTitle(NSAttributedString(string: "CHECK FOR UPGRADE", attributes: attributes), for: .normal)
        checkForUpgradeButton.addTarget(self, action: #selector(self.checkForUpgrade), for: UIControlEvents.touchUpInside)
    }
    
    @objc func checkForUpgrade() {
        checkForUpgradecallback?()
    }

}
