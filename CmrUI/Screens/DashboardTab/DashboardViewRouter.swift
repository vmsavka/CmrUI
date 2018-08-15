//
//  DashboardViewRouter.swift
//  CmrUI
//

import UIKit


protocol DashboardViewRouter: ViewRouter {
    func presentDashboardDetailed(for item: DashboardItem)
}

class DashboardViewRouterImplementation: DashboardViewRouter {
    fileprivate weak var dashboard: DashboardVC?
    fileprivate var dashboardItem: DashboardItem!
    
    init(dashboardVC: DashboardVC) {
        self.dashboard = dashboardVC
    }
    
    // MARK: - DashboardViewRouter
    
    func presentDashboardDetailed(for item: DashboardItem) {
        self.dashboardItem = item
        dashboard?.performSegue(withIdentifier: "BooksSceneToBookDetailsSceneSegue", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let dashboardDetailedVC = segue.destination as? DashboardDetailedVC {
        //    dashboardDetailsTableViewController.configurator = DashboardDetailsConfiguratorImplementation(item: DashboardItem)
        //}
    }
    
}
