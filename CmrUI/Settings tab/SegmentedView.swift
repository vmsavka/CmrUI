//
//  SegmentedView.swift
//  CmrUI
//

import UIKit

fileprivate struct SegmentedColours {
    static let selectedSegmentedColor = UIColor(red: 107.0/255.0, green: 170.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    static let deselectedSegmentedColor = UIColor(red: 153.0/255.0, green: 193.0/255.0, blue: 218.0/255.0, alpha: 1.0)
}

typealias SegmentedCallback = ((Int) -> Void)

class SegmentedView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedView: UISegmentedControl!

    var segmentedValueCallback: SegmentedCallback?
    var segments: [String]?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        segmentedView.layer.cornerRadius = segmentedView.frame.size.height / 2
        segmentedView.layer.borderWidth = 1
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.clipsToBounds = true
        
        segmentedView.tintColor = SegmentedColours.selectedSegmentedColor
        segmentedView.backgroundColor = UIColor.clear
        segmentedView.setDividerImage(UIImage.imageWithColor(color: UIColor.white), forLeftSegmentState: UIControlState.application, rightSegmentState: UIControlState.application, barMetrics: UIBarMetrics.default)
        segmentedView.addTarget(self, action: #selector(self.didChangeValue(forKey:)), for: UIControlEvents.valueChanged)
        
        segmentedView.removeAllSegments()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedView.setTitleTextAttributes(attributes, for: UIControlState.normal)
        segmentedView.setTitleTextAttributes(attributes, for: UIControlState.selected)
        //segmentedView.setDividerImage(UIImage(), forLeftSegmentState: UIControlState.normal, rightSegmentState: UIControlState.normal, barMetrics: UIBarMetrics.default)
        for segment in segments! {
            segmentedView.insertSegment(withTitle: segment, at: (segments?.index(of: segment))!, animated: false)
        }
        segmentedView.selectedSegmentIndex = 0
        
        segmentedView.addTarget(self, action: #selector(self.valueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func valueChanged() {
        segmentedValueCallback?(segmentedView.selectedSegmentIndex)
    }
    
    func selectIndex(index: Int?) {
        DispatchQueue.main.async {
            self.segmentedView.selectedSegmentIndex = index!
        }
    }
}
