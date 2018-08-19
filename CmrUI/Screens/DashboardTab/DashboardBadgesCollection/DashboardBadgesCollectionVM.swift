//
//  DashboardBadgesCollectionVM.swift
//  CmrUI
//

import UIKit

enum Badge {
    case adventurer
    case backer
    case first100
    case muzak
    case vacationer
    
    func title() -> String {
        switch self {
        case .adventurer:
            return "Adventurer"
        case .backer:
            return "Backer"
        case .first100:
            return "1st 100"
        case .muzak:
            return "Muzak"
        case .vacationer:
            return "Vacationer"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .adventurer:
            return UIImage(named: title())
        case .backer:
            return UIImage(named: title())
        case .first100:
            return UIImage(named: title())
        case .muzak:
            return UIImage(named: title())
        case .vacationer:
            return UIImage(named: title())
        }
    }
}

protocol DashboardBadgesCollectionVMProtocol {
    func reloadCells(indexes: [IndexPath])
    func reloadCollectionView()
}

class DashboardBadgesCollectionVM: NSObject {
    
    var statuses: [Badge]? = nil
    
    fileprivate var delegate: DashboardBadgesCollectionVMProtocol?
    
    fileprivate lazy var dataManager: DashboardManager = {
        let manager = DashboardManager.shared
        manager.controller = self
        return manager
    }()
    
    init(delegate: DashboardBadgesCollectionVMProtocol) {
        self.delegate = delegate
    }
    
    func loadUserBadges() {
        dataManager.loadUserBadges()
    }
}

extension DashboardBadgesCollectionVM: DashboardManagerProtocol {
    func onLoadUserBadgesSuccess(badges: [Badge]?) {
        self.statuses = badges
        delegate?.reloadCollectionView()
    }
    
    func onLoadUserBadgesFail(error: Error?) {}
    func onLoadAvailableBadgesSuccess(badges: [Badge]?) {}
    func onLoadAvailableBadgesFail(error: Error?) {}
    func onLoadBadgeInfoSuccess() {}
    func onLoadBadgeInfoFail(error: Error?) {}
}

