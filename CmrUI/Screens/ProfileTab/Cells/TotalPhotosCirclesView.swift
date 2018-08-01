//
//  TotalPhotosCirclesView.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 8/1/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerCircleWidth: CGFloat = 2
    static let cornerCircleColor = UIColor(red: 158.0/255.0, green: 191.0/255.0, blue: 204.0/255.0, alpha: 0.5)
}

class TotalPhotosCirclesView: UIView {
    
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.blue
        self.drawCornerCircles()
        
    }
    
    fileprivate func drawCornerCircles() {
        let minCircleRadius = frame.size.height * 0.5
        var radius = minCircleRadius
        var zoomimgArray: [CGFloat] = [0.0, 0.35, 0.8]
        for i in 0...2 {
            radius = minCircleRadius + frame.size.height * zoomimgArray[i]
            let rect = CGRect(x: frame.size.width - radius - 10,
                              y: frame.size.height - radius - 10,
                              width: radius,
                              height: radius)
            let context = UIGraphicsGetCurrentContext()
            context?.setLineWidth(Constants.cornerCircleWidth)
            context?.setStrokeColor(Constants.cornerCircleColor.cgColor)
            
            context?.translateBy(x: minCircleRadius / 2 - 10, y: minCircleRadius / 2 - 10)
            
            context?.addEllipse(in: rect)
            context?.strokePath()
            context?.saveGState()
        }
    }
}
