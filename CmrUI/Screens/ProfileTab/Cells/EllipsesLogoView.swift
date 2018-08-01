//
//  EllipsesLogoView.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/31/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let kLinearAccentricity: CGFloat = 0.37
    static let ellipseLineWidth: CGFloat = 5.0
    
    static let ellipseColor = UIColor.white
}

class EllipsesLogoView: UIView {
    var eccentricity: CGFloat = 0

    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup() {
        eccentricity = Constants.kLinearAccentricity * frame.size.height
        drawEllipse()
    }
    
    func drawEllipse() {
        let rect = CGRect(x: Constants.ellipseLineWidth / 2,
                          y:Constants.ellipseLineWidth / 2,
                          width: self.frame.size.width - Constants.ellipseLineWidth,
                          height: eccentricity)
        let rotatinEdge = CGFloat.pi / 3.0 //Rotation edge beetwen two ellipses 2Pi / 6
        let diametr = self.frame.size.width - Constants.ellipseLineWidth
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(Constants.ellipseLineWidth)
        context?.setStrokeColor(Constants.ellipseColor.cgColor)
        
        //Rotate to Pi / 2
        context?.translateBy(x: 3 * diametr / 4 - Constants.ellipseLineWidth, y: 0)
        context?.rotate(by: CGFloat.pi / 2.0)
        
        context?.addEllipse(in: rect)
        context?.strokePath()
        context?.saveGState()
        
        let context1 = UIGraphicsGetCurrentContext()
        context1?.setLineWidth(Constants.ellipseLineWidth)
        context1?.setStrokeColor(Constants.ellipseColor.cgColor)
        context1?.rotate(by: rotatinEdge)
        context1?.translateBy(x: -2 * Constants.ellipseLineWidth, y: -1 * frame.size.height / 2 - Constants.ellipseLineWidth)
        context1?.addEllipse(in: rect)
        context1?.strokePath()
        context1?.saveGState()
        
        let context2 = UIGraphicsGetCurrentContext()
        context2?.setLineWidth(Constants.ellipseLineWidth)
        context2?.setStrokeColor(Constants.ellipseColor.cgColor)
        context2?.translateBy(x: 2 * frame.size.height / 5 + 3, y: -frame.size.height / 3 + Constants.ellipseLineWidth)
        context2?.rotate(by: rotatinEdge)
        context2?.addEllipse(in: rect)
        context2?.strokePath()
        context2?.saveGState()
    }
    
    
    //  context?.addArc(center: CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2), radius: 15, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)

}
