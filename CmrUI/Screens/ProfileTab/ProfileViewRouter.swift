//
//  ProfileViewRouter.swift
//  CmrUI
//

import UIKit


protocol ProfileViewRouter: ViewRouter {
    func presentProfileDetailed(for item: ProfileItem)
}

class ProfileViewRouterImplementation: ProfileViewRouter {
    fileprivate weak var profile: ProfileVC?
    fileprivate var profileItem: ProfileItem!
    
    init(profileVC: ProfileVC) {
        self.profile = profileVC
    }
    
    // MARK: - ProfileViewRouter
    
    func presentProfileDetailed(for item: ProfileItem) {
        self.profileItem = item
        profile?.performSegue(withIdentifier: "BooksSceneToBookDetailsSceneSegue", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if let profileDetailedVC = segue.destination as? ProfileDetailedVC {
        //    profileDetailsTableViewController.configurator = ProfileDetailsConfiguratorImplementation(item: ProfileItem)
        //}
    }
    
}
