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

class GradientHelper: NSObject {

    class func addGradient(onTopOf view: UIView?, colors: [UIColor]?, start startPoint: CGPoint, end endPoint: CGPoint) {
        let layer: CALayer? = self.gradientLayer(for: view)
        if layer != nil {
            return
        }
        let gradient = CAGradientLayer()
        gradient.frame = view?.bounds ?? CGRect.zero
        var cgcolors = [AnyHashable]()
        for color: UIColor? in colors ?? [UIColor?]() {
            if let aColor = color?.cgColor {
                cgcolors.append(aColor)
            }
        }
        gradient.colors = cgcolors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        view?.layer.addSublayer(gradient)
        self.setGradientLayer(gradient, for: view)
    }
    
    class func gradientLayer(for view: UIView?) -> CALayer? {
        if view == nil || view?.layer.sublayers == nil {
            return nil
        }
        return objc_getAssociatedObject(self, &GradientLayerKey) as? CALayer
    }
    
    class func setGradientLayer(_ layer: CALayer?, for view: UIView?) {
        objc_setAssociatedObject(view ?? UIView(), &GradientLayerKey, layer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class func updateGradientLayerFrame(on view: UIView?) {
        let layer: CALayer? = self.gradientLayer(for: view)
        if layer != nil {
            layer?.frame = view?.bounds ?? CGRect.zero
        }
    }
    
}
