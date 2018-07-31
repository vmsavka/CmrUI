//
//  BatteryRemainingCell.swift
//  CmrUI
//

import UIKit

fileprivate struct Constants {
    static let animationKeyPath: String = "strokeEnd"
    static let animationCircleKeyPath: String = "animateCircle"
    static let thicknessCircle: CGFloat = 14
    static let kCircleRadius: CGFloat = 0.5
    static let verticalCircleOffset: CGFloat = 5
    static let kStartAxisCorner: CGFloat = -3.0 * CGFloat.pi / 5.0
    static let drawCircleSpeed: Float = 1.5 // full 2pi circle per 1.5 seconds
    static let viewCornerRadius: CGFloat = 15
    
    static let backgroundCircleColor = UIColor(red: 136.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
    static let circleColor = UIColor(red: 159.0/255.0, green: 193.0/255.0, blue: 205.0/255.0, alpha: 1.0)
}

class BatteryRemainingCell: UICollectionViewCell, ProfileCellView {
    
    @IBOutlet weak var batteryRemainingTitleLabel: UILabel!
    @IBOutlet weak var batteryRemainingValueLabel: UILabel!
    @IBOutlet weak var verticalOffsetConstraint: NSLayoutConstraint!
    
    var circleLayer: CAShapeLayer!
    var drawDuration: Double = 1
    var batteryLevel: Float = 0
    
    func displayBatteryLevel(percentage: Float) {
        batteryLevel = percentage
        drawDuration = Double(Constants.drawCircleSpeed * percentage / 100.0)
        
        //Display level value
        let formatter = NumberFormatter()
        formatter.roundingMode = .down
        let roundedLevel = formatter.string(from: NSNumber(value: percentage))
        if let value = roundedLevel {
            batteryRemainingValueLabel.text = value + "%"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = Constants.viewCornerRadius
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBackgroundCircleView()
        setup()
        addCircleView()
    }
    
    public func setup() {
        self.backgroundColor = UIColor.black
        let value = CGFloat.pi * CGFloat(batteryLevel) / 50.0 + Constants.kStartAxisCorner
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0,
                                                         y: frame.size.height / 2.0 - Constants.verticalCircleOffset),
                                      radius: frame.size.width * Constants.kCircleRadius / 2,
                                      startAngle: Constants.kStartAxisCorner,
                                      endAngle: value, clockwise: true)
        verticalOffsetConstraint.constant = -Constants.verticalCircleOffset
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = Constants.circleColor.cgColor
        circleLayer.lineWidth = Constants.thicknessCircle
        circleLayer.lineCap = kCALineCapRound
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    func addBackgroundCircleView() {
        let circleBackgroundPath = UIBezierPath(arcCenter:
            CGPoint(x: frame.size.width / 2.0,
                    y: frame.size.height / 2.0 - Constants.verticalCircleOffset),
                                                radius: frame.size.width * Constants.kCircleRadius / 2,
                                                startAngle: 0,
                                                endAngle: CGFloat.pi * 2, clockwise: true)
        
        let circleBackgroundLayer = CAShapeLayer()
        circleBackgroundLayer.path = circleBackgroundPath.cgPath
        circleBackgroundLayer.fillColor = UIColor.clear.cgColor
        circleBackgroundLayer.strokeColor = Constants.backgroundCircleColor.cgColor
        circleBackgroundLayer.lineWidth = Constants.thicknessCircle

        layer.addSublayer(circleBackgroundLayer)
    }
    
    func addCircleView() {
        // Animate the drawing of the circle over the course of 1 second
        animateCircle(duration: TimeInterval(drawDuration))
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: Constants.animationKeyPath)
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (The speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // Right value when the animation ends
        circleLayer.strokeEnd = 1
        
        // Do the actual animation
        circleLayer.add(animation, forKey: Constants.animationCircleKeyPath)
    }
}

// MARK: ProfileCellView protocol

extension BatteryRemainingCell {
    func display(title: String) {
        batteryRemainingTitleLabel.text = title
    }
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }
    
    func display(image: UIImage) {}
    
    func display(date: Date) {}
}
