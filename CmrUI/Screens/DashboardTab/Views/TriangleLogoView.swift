//
//  TriangleLogoView.swift
//  Elll
//

import UIKit

fileprivate struct Constants {
    static let borderColor = UIColor(red: 248.0/255.0, green: 219.0/255.0, blue: 74.0/255.0, alpha: 1.0)
}

class TriangleLogoView: UIView {
    fileprivate typealias c = Constants
    
    func addTriangleBorderLayer(bezierPath: UIBezierPath) {
        let currentContext = UIGraphicsGetCurrentContext()
        let lineWidth: CGFloat = frame.size.width / 21.0
        guard let context = currentContext else { return }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.borderColor = UIColor.yellow.cgColor
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.edgeAntialiasingMask = .layerTopEdge
        shapeLayer.lineJoin = "round"
        shapeLayer.lineCap = "round"
        shapeLayer.strokeColor = c.borderColor.cgColor
        
        context.drawPath(using: .stroke)
        shapeLayer.draw(in: context)
        self.layer.addSublayer(shapeLayer)
    }
}
