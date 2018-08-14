//
//  DetailedBadgeInfoVM.swift
//  CmrUI
//

import UIKit

protocol DetailedBadgeInfoVMProtocol {
    func reloadPage()
}

class DetailedBadgeInfoVM: NSObject {
    var badge: Badge?
    
    fileprivate var delegate: DetailedBadgeInfoVMProtocol?
    
    fileprivate lazy var dataManager: ProfileManager = {
        let manager = ProfileManager.shared
        manager.controller = self
        return manager
    }()
    
    init(delegate: DetailedBadgeInfoVMProtocol) {
        self.delegate = delegate
    }
    
    func loadDetailedBadgeInfo() {
        dataManager.loadBadgeInfo(badge: badge)
    }
}

extension DetailedBadgeInfoVM: ProfileManagerProtocol {
    func onLoadBadgeInfoSuccess() {
        delegate?.reloadPage()
    }
    
    func onLoadBadgeInfoFail(error: Error?) {}
    func onLoadAvailableBadgesSuccess(badges: [Badge]?) {}
    func onLoadAvailableBadgesFail(error: Error?) {}
    func onLoadUserBadgesSuccess(badges: [Badge]?) {}
    func onLoadUserBadgesFail(error: Error?) {}
}
