//
//  ProfileBadgesCollectionVM.swift
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

protocol ProfileBadgesCollectionVMProtocol {
    func reloadCells(indexes: [IndexPath])
    func reloadCollectionView()
}

class ProfileBadgesCollectionVM: NSObject {
    
    var statuses: [Badge]? = nil
    
    fileprivate var delegate: ProfileBadgesCollectionVMProtocol?
    
    fileprivate lazy var dataManager: ProfileManager = {
        let manager = ProfileManager.shared
        manager.controller = self
        return manager
    }()
    
    init(delegate: ProfileBadgesCollectionVMProtocol) {
        self.delegate = delegate
    }
    
    func loadUserBadges() {
        dataManager.loadUserBadges()
    }
}

extension ProfileBadgesCollectionVM: ProfileManagerProtocol {
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

