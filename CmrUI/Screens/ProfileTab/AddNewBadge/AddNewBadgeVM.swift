//
//  AddNewBadgeVM.swift
//  CmrUI
//

import UIKit

protocol AddNewBadgeVMProtocol {
    func reloadCells(indexes: [IndexPath])
    func reloadBadges()
}

class AddNewBadgeVM: NSObject {
    var badges: [Badge]? = nil
    
    fileprivate var delegate: AddNewBadgeVMProtocol?
    
    fileprivate lazy var dataManager: ProfileManager = {
        let manager = ProfileManager.shared
        manager.controller = self
        return manager
    }()
    
    init(delegate: AddNewBadgeVMProtocol) {
        self.delegate = delegate
    }
    
    func loadAvailableBadges() {
        dataManager.loadAvailableBadges()
    }
}

extension AddNewBadgeVM: ProfileManagerProtocol {
    
    func onLoadAvailableBadgesSuccess(badges: [Badge]?) {
        self.badges = badges
        delegate?.reloadBadges()
    }
    
    func onLoadAvailableBadgesFail(error: Error?) {}
    func onLoadUserBadgesSuccess(badges: [Badge]?) {}
    func onLoadUserBadgesFail(error: Error?) {}
    func onLoadBadgeInfoSuccess() {}
    func onLoadBadgeInfoFail(error: Error?) {}
}
