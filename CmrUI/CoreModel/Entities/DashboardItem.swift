//
//  DashboardItem.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/29/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

public enum DashboardItemType: Int {
    case dashboardInfo = 0
    case batteryRemaining = 1
    case sunsetRemaining = 2
    case photosTotalChart = 3
    
    case count = 4
}

public class DashboardItem: NSObject {
    var title: String? = nil
    var subtitle: String? = nil
    var backgroundColor: UIColor? = nil
    var dashboardItemType: DashboardItemType? = nil
    
    init(title: String,
         background: UIColor,
         itemType: DashboardItemType) {
        self.title = title
        self.backgroundColor = background
        self.dashboardItemType = itemType
    }
}
