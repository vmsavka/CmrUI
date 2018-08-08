//
//  EllipticCurvesView.swift
//  CmrUI
//

import UIKit

fileprivate struct Constants {
    static let ellipseLineWidth: CGFloat = 4
    static let ellipseColor = UIColor.white
    static let kEllipseVisibleWidth: CGFloat = 0.29
    static let kEllipseVisibleHeight: CGFloat = 0.18
    static let kBezierTangent: CGFloat = 0.3
    static let ellipsesEngle: CGFloat = CGFloat.pi / 3.0
    static let kIntersectPos: CGFloat = 0.277
    static let kIntersectXPos: CGFloat = 0.136
    static let kIntersectYPos: CGFloat = 0.238
    static let kTriangleControlPoint: CGFloat = 0.195
    static let kTransparentMaskOffset: CGFloat = 0.02
    static let kLogoPositionOffset: CGFloat = 0.014
}

class EllipticCurvesView: UIView {
    
    var logoSuperview: EllipsesLogoView!
    
    var path: UIBezierPath! = nil
    fileprivate typealias c = Constants
    
    override func draw(_ rect: CGRect) {
        setup()
    }
    
    func setup() {
        complexShape()
        innerTriangle()
    }
    
    //Draw elliptic curves
    
    func complexShape() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let centerPoint: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        let currentContext = UIGraphicsGetCurrentContext()
        guard let context = currentContext else { return }
        context.setLineWidth(Constants.ellipseLineWidth)
        context.setStrokeColor(Constants.ellipseColor.cgColor)
        
        var startPoint: CGPoint = CGPoint(x: (width - width * c.kEllipseVisibleWidth) / 2.0,
                                          y: (height - height * c.kEllipseVisibleHeight) / 2.0)
        var endPoint: CGPoint = CGPoint(x: width - (width - width * c.kEllipseVisibleWidth) / 2.0,
                                        y: (height - height * c.kEllipseVisibleHeight) / 2.0)
        var controlPoint: CGPoint = CGPoint(x: width / 2, y: -height * c.kBezierTangent)
        
        path = UIBezierPath()
        
        for i in 0...5 {
            if i > 0 {
                startPoint = self.calculateSlopePoint(p0: centerPoint, p1: startPoint)
                endPoint = self.calculateSlopePoint(p0: centerPoint , p1: endPoint)
                controlPoint = self.calculateSlopePoint(p0: centerPoint, p1: controlPoint)
            }
            
            self.path.move(to: startPoint)
            self.path.addQuadCurve(to: endPoint,
                                   controlPoint: controlPoint)
        }
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = c.ellipseLineWidth
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.strokeColor = Constants.ellipseColor.cgColor
        shapeLayer.lineCap = "round"
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.shadowOffset = CGSize(width: 2, height: 2)
        
        context.drawPath(using: .stroke)
        shapeLayer.draw(in: context)
        self.layer.addSublayer(shapeLayer)
        
        animateEllipse(layer: shapeLayer)
    }
    
    //Draw triangle curves
    
    func innerTriangle() {
        
        //Calculate triangle points
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let centerPoint: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        let firstPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos,
                                          y: centerPoint.y - height * c.kIntersectYPos)
        let secondPoint: CGPoint = CGPoint(x: centerPoint.x + width * c.kIntersectPos * 0.95, y: centerPoint.y)
        let thirdPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos,
                                          y: centerPoint.y + height * c.kIntersectYPos)
        let imageRect = CGRect(x: firstPoint.x, y: firstPoint.y, width: secondPoint.x - firstPoint.x, height: thirdPoint.y - firstPoint.y)
        
        // Draw triangle mask
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = imageRect
        let maskPath = drawTriangleMaskPath()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = CGRect(x: 0, y: 0, width: maskLayer.frame.size.width, height: maskLayer.frame.size.height)
        self.mask(withPath: maskPath, inverse: true)
        
        //Draw triangle image view
        let trianglePath = drawTriangleLogoPath()
        logoSuperview.addMaskLayer(bezierPath: trianglePath)
    }
    
    func drawTriangleLogoPath() -> UIBezierPath {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let maskPositionOffset = c.kLogoPositionOffset * width
        let centerPoint: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        let firstPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos + maskPositionOffset,
                                          y: centerPoint.y - height * c.kIntersectYPos + maskPositionOffset * 1.6)
        let secondPoint: CGPoint = CGPoint(x: centerPoint.x + width * c.kIntersectPos * 0.95 - maskPositionOffset, y: centerPoint.y)
        let thirdPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos + maskPositionOffset,
                                          y: centerPoint.y + height * c.kIntersectYPos - maskPositionOffset * 1.6)
        
        let trianglePath = UIBezierPath()
        trianglePath.lineJoinStyle = .round
        trianglePath.lineCapStyle = .square
        trianglePath.move(to: firstPoint)
        
        var controlPoint: CGPoint = CGPoint(x: centerPoint.x + width * c.kTriangleControlPoint * cos(c.ellipsesEngle),
                                            y: centerPoint.y - height * c.kTriangleControlPoint * sin(c.ellipsesEngle))
        trianglePath.addQuadCurve(to: secondPoint, controlPoint: controlPoint)
        controlPoint = CGPoint(x: centerPoint.x + width * c.kTriangleControlPoint * cos(c.ellipsesEngle),
                               y: centerPoint.y + height * c.kTriangleControlPoint * sin(c.ellipsesEngle))
        trianglePath.addQuadCurve(to: thirdPoint, controlPoint: controlPoint)
        controlPoint = CGPoint(x: centerPoint.x - width * c.kTriangleControlPoint,
                               y: centerPoint.y)
        trianglePath.addQuadCurve(to: firstPoint, controlPoint: controlPoint)
        
        trianglePath.fill()
        trianglePath.close()
        
        return trianglePath
    }
    
    func drawTriangleMaskPath() -> UIBezierPath {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let maskOffset = c.kTransparentMaskOffset * width
        let centerPoint: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        let firstPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos,
                                          y: centerPoint.y - height * c.kIntersectYPos)
        let secondPoint: CGPoint = CGPoint(x: centerPoint.x + width * c.kIntersectPos, y: centerPoint.y)
        let thirdPoint: CGPoint = CGPoint(x: centerPoint.x - width * c.kIntersectXPos,
                                          y: centerPoint.y + height * c.kIntersectYPos)
        
        //Draw elliptic curves
        let trianglePath = UIBezierPath()
        trianglePath.lineJoinStyle = .round
        trianglePath.lineCapStyle = .square
        trianglePath.move(to: firstPoint)
        
        var controlPoint: CGPoint = CGPoint(x: centerPoint.x + width * c.kTriangleControlPoint * cos(c.ellipsesEngle) + maskOffset,
                                            y: centerPoint.y - height * c.kTriangleControlPoint * sin(c.ellipsesEngle) - maskOffset)
        trianglePath.addQuadCurve(to: secondPoint, controlPoint: controlPoint)
        controlPoint = CGPoint(x: centerPoint.x + width * c.kTriangleControlPoint * cos(c.ellipsesEngle) + maskOffset,
                               y: centerPoint.y + height * c.kTriangleControlPoint * sin(c.ellipsesEngle) + maskOffset)
        trianglePath.addQuadCurve(to: thirdPoint, controlPoint: controlPoint)
        controlPoint = CGPoint(x: centerPoint.x - width * c.kTriangleControlPoint - maskOffset,
                               y: centerPoint.y)
        trianglePath.addQuadCurve(to: firstPoint, controlPoint: controlPoint)
        trianglePath.close()
        
        return trianglePath
    }
    
    
    func animateEllipse(layer: CALayer) {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        /* set up animation */
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.6
        
        layer.add(animation, forKey: "drawLineAnimation")
    }
}

// MARK : calculations

extension EllipticCurvesView {
    func calculateSlopePoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
        //By Pythagorean theorem
        let radius: CGFloat = sqrt(pow(p0.x - p1.x, 2) + pow(p0.y - p1.y, 2))
        
        //Calculate angle of point p0 to X axis
        var startAngle = acos((p1.x - p0.x) / radius)
        startAngle = p1.y < p0.y ? -startAngle : startAngle
        
        //Calculate angle of shifted point to X axis
        var shiftedAngle = startAngle + c.ellipsesEngle
        
        //Cross over full cicle to feet bounds -π <= x <= π
        shiftedAngle = shiftedAngle > CGFloat.pi ? shiftedAngle - 2.0 * CGFloat.pi : shiftedAngle
        
        let xw = radius * cos(shiftedAngle)
        let yw = radius * sin(shiftedAngle)
        
        let px: CGPoint = CGPoint(x: p0.x + xw, y: p0.y + yw)
        
        return px
    }
}

extension UIView {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        self.layer.mask = maskLayer
    }
}
