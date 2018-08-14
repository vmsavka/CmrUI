//
//  EllipsesLogoView.swift
//  Elll
//

import UIKit

fileprivate struct Constants {
    static let lineWidth: CGFloat = 0.0
    static let borderColor = UIColor(red: 248.0/255.0, green: 219.0/255.0, blue: 74.0/255.0, alpha: 1.0)
}

class EllipsesLogoView: UIView {
    
    @IBOutlet weak var ellipsesView: EllipticCurvesView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoBackground: TriangleLogoView!
    var image: UIImage? = UIImage(named: "profilePhoto")
    fileprivate typealias c = Constants
    
    override func draw(_ rect: CGRect) {
        ellipsesView.logoSuperview = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func addMaskLayer(bezierPath: UIBezierPath) {
        let currentContext = UIGraphicsGetCurrentContext()
        guard let context = currentContext else { return }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = c.lineWidth
        shapeLayer.borderColor = c.borderColor.cgColor
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.edgeAntialiasingMask = .layerBottomEdge
        shapeLayer.lineJoin = "round"
        shapeLayer.strokeColor = c.borderColor.cgColor
        shapeLayer.draw(in: context)
        
        logoImageView.image = image
        logoBackground.layer.mask = shapeLayer
        logoBackground.bringSubview(toFront: self)
        self.addSubview(logoBackground)
        logoBackground.translatesAutoresizingMaskIntoConstraints = false
   
        NSLayoutConstraint.activate([
            logoBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            logoBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            logoBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            logoBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        logoBackground.addTriangleBorderLayer(bezierPath: bezierPath)
    }
}
