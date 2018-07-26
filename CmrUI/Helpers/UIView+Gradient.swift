//
//  GradientHelper.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/19/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit
import ObjectiveC

private let GradientLayerName: String = "gradientLayer"

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
        gradient.name = GradientLayerName
    }
    
    func gradientLayer() -> CALayer? {
        if self.layer.sublayers == nil {
            return nil
        }
        let layerArray = self.layer.sublayers?.filter({ $0.name == GradientLayerName  })
        if layerArray?.isEmpty == false {
            return layerArray?[0]
        }
        else {
            return nil
        }
    }
    
    func updateGradientLayerFrame() {
        let layer: CALayer? = self.gradientLayer()
        if layer != nil {
            layer?.frame = self.bounds 
        }
    }
}
