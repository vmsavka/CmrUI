//
//  SettingsPropertyView.swift
//  CmrUI
//

import UIKit

typealias PurchaseMoreStorageCallback = (() -> Void)

class SettingsPropertyView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var squareLabel: UILabel!
    @IBOutlet weak var squareSubLabel: UILabel!
    var borderColor: UIColor? = nil
    var purchaseCallback: SettingsPropertyView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        circleView.layer.cornerRadius = circleView.frame.size.height / 2
        circleView.layer.borderWidth = 4
        circleView.layer.borderColor = borderColor?.cgColor
        
        squareView.layer.borderWidth = 4
        squareView.layer.borderColor = borderColor?.cgColor
    }
    
    func setBordColor(color: UIColor?) {
        borderColor = color
    }
 

}
