//
//  DashboardManager.swift
//  CmrUI
//

import Foundation
import UIKit

protocol DashboardManagerProtocol {
    func onLoadUserBadgesSuccess(badges: [Badge]?)
    func onLoadUserBadgesFail(error: Error?)
    
    func onLoadAvailableBadgesSuccess(badges: [Badge]?)
    func onLoadAvailableBadgesFail(error: Error?)
    
    func onLoadBadgeInfoSuccess()
    func onLoadBadgeInfoFail(error: Error?)
}

class DashboardManager: NSObject {
    static var shared = DashboardManager()
    var controller: DashboardManagerProtocol?
    
    var userBadges: [Badge]? = [Badge.adventurer,
                              Badge.backer,
                              Badge.first100,
                              Badge.muzak,Badge.vacationer]
    
    var availableBadges: [Badge]? = [Badge.adventurer,
                                Badge.backer,
                                Badge.first100,
                                Badge.muzak,Badge.vacationer]
    
    
    
    //fileprivate let api = ApiClientFactory.agency(baseURL: BaseUrl.url, authToken: nil)
    
    func loadUserBadges() {
        //Use Promise Kit
        //api.loadUserBadges()
        //    .always { [weak controller] in
        //        controller?.loader(visible: false)
        //    }.then { [weak controller] badges -> Void in
                controller?.onLoadUserBadgesSuccess(badges: userBadges)
        //    }
        //    .catch { [weak controller] error in
        //        controller?.onLoadUserBadgesFail(error: error)
        //}
    }
    
    func loadAvailableBadges() {
        //api.loadAvailableBadges()
        //    .always { [weak controller] in
        //        controller?.loader(visible: false)
        //    }.then { [weak controller] badges -> Void in
        controller?.onLoadAvailableBadgesSuccess(badges: availableBadges)
        //    }
        //    .catch { [weak controller] error in
        //        controller?.onLoadDashboardStatusesFail(error: error)
        //}
    }
    
    func loadBadgeInfo(badge: Badge?) {
        //api.loadBadgeInfo(badge: Badge)
        //    .always { [weak controller] in
        //        controller?.loader(visible: false)
        //    }.then { [weak controller] data -> Void in
            controller?.onLoadBadgeInfoSuccess()
        //    }
        //    .catch { [weak controller] error in
        //        controller?.onLoadBadgeInfoFail(error: error)
        //}
    }
}
