//
//  DisplayDashboardHandler.swift
//  CmrUI
//

import UIKit
import Foundation

typealias DisplayDashboardCompletionHandler = (_ dashboardItemsArray: Result<[DashboardItem]>) -> Void

protocol DisplayDashboardHandler {
    func displayDashboard(completionHandler: @escaping DisplayDashboardCompletionHandler)
}

class DisplayDashboardHandlerImplementation: DisplayDashboardHandler {
    let dashboardItemsArray: [DashboardItem]
    
    init(dashboardItems: [DashboardItem]?) {
        self.dashboardItemsArray = dashboardItems ?? []
    }
    
    // MARK: - DisplayDashboardHandler
    
    func displayDashboard(completionHandler: @escaping (Result<[DashboardItem]>) -> Void) {
        
        completionHandler(.success(dashboardItemsArray))
    }
}
