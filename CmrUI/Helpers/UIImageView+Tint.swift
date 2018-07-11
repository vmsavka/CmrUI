//
//  UIImageView+Tint.swift
//  CmrUI
//

import UIKit

extension UIImageView {
    func setTint(color: UIColor) {
        if let image = self.image {
            self.image = image.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
    }
}
