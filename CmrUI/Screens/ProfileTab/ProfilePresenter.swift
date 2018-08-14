//
//  ProfilePresenter.swift
//  CmrUI
//

import Foundation
import UIKit

protocol ProfileTabView: class {
    func refreshProfileView()
    func displayProfileRetrievalError(title: String, message: String)
}

protocol ProfileCellView {
    func display(title: String)
    func display(image: UIImage)
    func display(date: Date)
    func setBackground(color: UIColor)
}

protocol ProfilePresenter {
    var count: Int { get }
    var router: ProfileViewRouter { get }
    func viewDidLoad()
    func configure(cell: ProfileCellView, forRow row: Int)
    func didSelect(row: Int)
    func addButtonPressed()
}

class ProfilePresenterImplementation: ProfilePresenter {
    var count: Int = 0
    //Can be expanded with Detailed Profile presenter
    fileprivate weak var view: ProfileTabView?
    fileprivate let displayProfileHandler: DisplayProfileHandler
    internal let router: ProfileViewRouter
    
    var profile = [ProfileItem]()
    
    var numberOfProfile: Int {
        return profile.count
    }
    
    init(view: ProfileTabView,
         displayProfileHandler: DisplayProfileHandler,
         router: ProfileViewRouter) {
        self.view = view
        self.displayProfileHandler = displayProfileHandler
        self.router = router
        displayProfileHandler.displayProfile { [weak self] profileItemsArray in
            do {
                self?.count = (try profileItemsArray.dematerialize()).count
            }
            catch {}
        }
    }
    
    // MARK: - ProfilePresenter
    
    func viewDidLoad() {
        self.displayProfileHandler.displayProfile { (result) in
            switch result {
            case let .success(Profile):
                self.handleProfileReceived(Profile)
            case let .failure(error):
                self.handleProfileError(error)
            }
        }
    }
    
    func configure(cell: ProfileCellView, forRow row: Int) {
        let profileItem = profile[row]
        
        cell.display(title: profileItem.title ?? "")
        //cell.setBackground(color: UIColor.grey)
        
        let type = profileItem.profileItemType
        
        switch type {
        case .profileInfo?:
            if let profileCell = cell as? ProfileInfoCell {
                profileCell.display(title: "Platinum")
                profileCell.display(name: "Mathew Frischer")
                profileCell.display(description: "Member Since '18")
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
        let profileItem = profile[row]
        
        router.presentProfileDetailed(for: profileItem)
    }
    
    func addButtonPressed() {
    }
    
    // MARK: - Private
    
    fileprivate func handleProfileReceived(_ profileArray: [ProfileItem]) {
        self.profile = profileArray
        view?.refreshProfileView()
    }
    
    fileprivate func handleProfileError(_ error: Error) {
        view?.displayProfileRetrievalError(title: "Error", message: error.localizedDescription)
    }
}
