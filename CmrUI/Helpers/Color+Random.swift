//
//  Color+Random.swift
//  CmrUI
//

import Foundation
import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(255))/255.0,
            green: CGFloat(arc4random_uniform(255))/255.0,
            blue: CGFloat(arc4random_uniform(255))/255.0,
            alpha: 1.0)
    }
}
