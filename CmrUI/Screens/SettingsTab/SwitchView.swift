//
//  SwitchView.swift
//  CmrUI
//

import UIKit
fileprivate struct SwitchColours {
    static let narrationSwithColor = UIColor(red: 107.0/255.0, green: 170.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    static let narrationSwithButtonColor = UIColor(red: 153.0/255.0, green: 193.0/255.0, blue: 218.0/255.0, alpha: 1.0)
}

typealias SwitchCallback = ((Int) -> Void)

class SwitchView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!
    var swichValueCallback: SwitchCallback?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switchView.tintColor = SwitchColours.narrationSwithButtonColor
        switchView.onTintColor = SwitchColours.narrationSwithColor
        switchView.addTarget(self, action: #selector(self.switchValue(sender:)), for: UIControlEvents.valueChanged)
    }

    @objc func switchValue(sender: UISwitch) {
        let value: Int = sender.isOn ? 1 : 0
        swichValueCallback?(value)
    }
}
