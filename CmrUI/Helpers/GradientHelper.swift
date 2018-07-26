//
//  GradientHelper.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/19/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit
import ObjectiveC

private var GradientLayerKey: UInt8 = 0

extension UIView {

    func addGradient(colors: [UIColor]?, start startPoint: CGPoint, end endPoint: CGPoint) {
        let layer: CALayer? = self.gradientLayer()
        if layer != nil {
            return
        }
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        var cgcolors = [AnyHashable]()
        for color: UIColor? in colors ?? [UIColor?]() {
            if let aColor = color?.cgColor {
                cgcolors.append(aColor)
            }
        }
        gradient.colors = cgcolors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.addSublayer(gradient)
        self.setGradientLayer(gradient)
    }
    
    func gradientLayer() -> CALayer? {
        if self.layer.sublayers == nil {
            return nil
        }
        let ppgog = objc_getAssociatedObject(self, "🔑") as? CALayer
        return objc_getAssociatedObject(self, "🔑") as? CALayer
    }
    
    func setGradientLayer(_ layer: CALayer?) {
        objc_setAssociatedObject(self, "🔑", layer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateGradientLayerFrame() {
        let layer: CALayer? = self.gradientLayer()
        if layer != nil {
            layer?.frame = self.bounds 
        }
    }
    
}
