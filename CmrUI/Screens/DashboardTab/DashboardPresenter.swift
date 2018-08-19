//
//  DashboardPresenter.swift
//  CmrUI
//

import Foundation
import UIKit

protocol DashboardTabView: class {
    func refreshDashboardView()
    func displayDashboardRetrievalError(title: String, message: String)
}

protocol DashboardCellView {
    func display(title: String)
    func display(image: UIImage)
    func display(date: Date)
    func setBackground(color: UIColor)
}

protocol DashboardPresenter {
    var count: Int { get }
    var router: DashboardViewRouter { get }
    func viewDidLoad()
    func configure(cell: DashboardCellView, forRow row: Int)
    func didSelect(row: Int)
    func addButtonPressed()
}

class DashboardPresenterImplementation: DashboardPresenter {
    var count: Int = 0
    //Can be expanded with Detailed Dashboard presenter
    fileprivate weak var view: DashboardTabView?
    fileprivate let displayDashboardHandler: DisplayDashboardHandler
    internal let router: DashboardViewRouter
    
    var dashboard = [DashboardItem]()
    
    var numberOfDashboard: Int {
        return dashboard.count
    }
    
    init(view: DashboardTabView,
         displayDashboardHandler: DisplayDashboardHandler,
         router: DashboardViewRouter) {
        self.view = view
        self.displayDashboardHandler = displayDashboardHandler
        self.router = router
        displayDashboardHandler.displayDashboard { [weak self] dashboardItemsArray in
            do {
                self?.count = (try dashboardItemsArray.dematerialize()).count
            }
            catch {}
        }
    }
    
    // MARK: - DashboardPresenter
    
    func viewDidLoad() {
        self.displayDashboardHandler.displayDashboard { (result) in
            switch result {
            case let .success(Dashboard):
                self.handleDashboardReceived(Dashboard)
            case let .failure(error):
                self.handleDashboardError(error)
            }
        }
    }
    
    func configure(cell: DashboardCellView, forRow row: Int) {
        let dashboardItem = dashboard[row]
        
        cell.display(title: dashboardItem.title ?? "")
        //cell.setBackground(color: UIColor.grey)
        
        let type = dashboardItem.dashboardItemType
        
        switch type {
        case .dashboardInfo?:
            if let dashboardCell = cell as? DashboardInfoCell {
                dashboardCell.display(title: "Platinum")
                dashboardCell.display(name: "Mathew Frischer")
                dashboardCell.display(description: "Member Since '18")
            }
        case .batteryRemaining?:
            if let batteryCell = cell as? BatteryRemainingCell {
                batteryCell.display(title: "Battery Remaining")
                batteryCell.displayBatteryLevel(percentage: 65.5)
            }
        case .sunsetRemaining?:
            if let sunsetCell = cell as? SunsetRemainingCell {
                sunsetCell.display(title: "hrs.\nuntil sunset")
                sunsetCell.displayTime(hoursRemaining: 22)
                sunsetCell.display(image: UIImage(named: "sunset") ?? UIImage())
            }
        case .photosTotalChart?:
            if let chartCell = cell as? TotalPhotosChartCell {
                chartCell.display(title: "Photos - Total")
                chartCell.displayPhotosCount(totalValue: 179)
                chartCell.dispalyPhotoesStatistics(["2018/05/02" : 6, "2018/01/15" : 33, "2018/01/08" : 2, "2018/01/01" : 11, "2018/03/08" : 20, "2018/02/28" : 3])
                chartCell.setProgressIndicator(isEnabled: false)
            }
        default: break
        }
    }
    
    func didSelect(row: Int) {
        let dashboardItem = dashboard[row]
        
        router.presentDashboardDetailed(for: dashboardItem)
    }
    
    func addButtonPressed() {
    }
    
    // MARK: - Private
    
    fileprivate func handleDashboardReceived(_ dashboardArray: [DashboardItem]) {
        self.dashboard = dashboardArray
        view?.refreshDashboardView()
    }
    
    fileprivate func handleDashboardError(_ error: Error) {
        view?.displayDashboardRetrievalError(title: "Error", message: error.localizedDescription)
    }
}
