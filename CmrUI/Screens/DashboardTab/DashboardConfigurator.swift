//
//  DashboardConfigurator.swift
//  CmrUI
//

import Foundation
import UIKit

protocol DashboardConfigurator {
    func configure(dashboardVC: DashboardVC)
}

class DashboardConfiguratorImplementation: DashboardConfigurator {
    
    func configure(dashboardVC: DashboardVC) {
        let dashboardItems = [
            DashboardItem(title: "Platinum", background: UIColor.darkGray, itemType: DashboardItemType.dashboardInfo),
            DashboardItem(title: "Battery Remaining", background: UIColor.black, itemType: DashboardItemType.batteryRemaining),
            DashboardItem(title: "hrs./nuntil sunset", background: UIColor.orange, itemType: DashboardItemType.sunsetRemaining),
            DashboardItem(title: "Photos - Total", background: UIColor.blue, itemType: DashboardItemType.photosTotalChart)
        ]
        let displayDashboardHandler = DisplayDashboardHandlerImplementation(dashboardItems: dashboardItems)
        let router = DashboardViewRouterImplementation(dashboardVC: dashboardVC)
        
        let presenter = DashboardPresenterImplementation(view: dashboardVC,
                                                       displayDashboardHandler: displayDashboardHandler,
                                                       router: router)
        
        dashboardVC.presenter = presenter
    }
}
