//
//  NavigationRouter.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/13/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class NavigationRouter: NSObject {
    static let shared = NavigationRouter()
    
    public weak var navigationContiner: CmrContainerVC?
    
    func refreshNavigationBar(fromView view: UIView) {
        navigationContiner?.updateBarButtons(fromView: view)
    }
    
    func presentBarController() {
        let board = UIStoryboard.storyboardWith(name: .cmrContainer)
        let controller = board.instantiateInitialViewController()
        controller?.loadView()
        
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
    func getTopViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate
        if let window = appDelegate!.window {
            return window?.rootViewController
        }
        return nil
    }
    
    func showNewsFeedScreen() {
        let board = UIStoryboard.storyboardWith(name: .newsFeed)
        let controller = board.instantiateViewController(withIdentifier: "NewsFeedVC")
        if let currentController = UIApplication.shared.keyWindow?.rootViewController {
            currentController.view.removeFromSuperview()
        }
        
        if let nav = controller as? UINavigationController,
            let _ = nav.viewControllers[0] as? NewsFeedVC {
        }
        
        UIApplication.shared.keyWindow?.rootViewController = controller
    }
}
