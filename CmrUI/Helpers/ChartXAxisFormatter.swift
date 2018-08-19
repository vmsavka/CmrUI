//
//  ChartXAxisFormatter.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 8/1/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    var isDayVisible: Bool = false
    var isYearVisible: Bool = false
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let _ = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        
        let year = NSCalendar.current.component(.year, from: date)
        let month = NSCalendar.current.component(.month, from: date)
        let day = NSCalendar.current.component(.day, from: date)
        var stringMonth = months[month - 1]
        
        if isDayVisible {
            stringMonth = stringMonth + " \(day)"
        }
        if isYearVisible {
            stringMonth = stringMonth + ", \(year) "
        }
        return stringMonth
    }
}
