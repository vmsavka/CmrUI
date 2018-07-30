//
//  ProfileConfigurator.swift
//  CmrUI
//

import Foundation
import UIKit

protocol ProfileConfigurator {
    func configure(profileVC: ProfileVC)
}

class ProfileConfiguratorImplementation: ProfileConfigurator {
    
    func configure(profileVC: ProfileVC) {
        let profileItems = [
            ProfileItem(title: "Platinum", background: UIColor.darkGray, itemType: ProfileItemType.profileInfo),
            ProfileItem(title: "Battery Remaining", background: UIColor.black, itemType: ProfileItemType.batteryRemaining),
            ProfileItem(title: "hrs./nuntil sunset", background: UIColor.orange, itemType: ProfileItemType.sunsetRemaining),
            ProfileItem(title: "Photos - Total", background: UIColor.blue, itemType: ProfileItemType.photosTotalChart)
        ]
        let displayProfileHandler = DisplayProfileHandlerImplementation(profileItems: profileItems)
        let router = ProfileViewRouterImplementation(profileVC: profileVC)
        
        let presenter = ProfilePresenterImplementation(view: profileVC,
                                                       displayProfileHandler: displayProfileHandler,
                                                       router: router)
        
        profileVC.presenter = presenter
    }
}
