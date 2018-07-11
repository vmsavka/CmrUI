//
//  CmrTabBar+DataSource.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/10/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

fileprivate struct CmrTabBarItems {
    static let feedItem = 0
    static let galleryItem = 1
    static let itemsItem = 2
    static let settingsItem = 3
    static let cartItem = 4
}

extension CmrTabBar {
    
    func setupControllers() {
        
        let feedController = UIViewController() //FeedController()
        feedController.tabBarItem = UITabBarItem.init(title: "", image: UIImage.init(named: "GalleryTabBarIco"), tag: 0)
            //UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: CmrTabBarItems.feedItem)!, tag: 0)
        feedController.tabBarItem.imageInsets = UIEdgeInsetsMake( 0, 10, 0, -10);
        
        let galleryController = UIViewController() //GalleryController()
        galleryController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: CmrTabBarItems.galleryItem)!, tag: 1)
        galleryController.tabBarItem.imageInsets = UIEdgeInsetsMake( 0, 5, 0, -5);
        
        let itemsItem = UIViewController() //AllItemsViewController()
        itemsItem.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: CmrTabBarItems.itemsItem)!, tag: 2)
        
        let settingsItem = UIViewController() //SettingsViewController()
        settingsItem.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: CmrTabBarItems.settingsItem)!, tag: 3)
        settingsItem.tabBarItem.imageInsets = UIEdgeInsetsMake( 0, 5, 0, -5);
        
        let cartItem = UIViewController() //CartViewController()
        cartItem.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem(rawValue: CmrTabBarItems.cartItem)!, tag: 4)
        cartItem.tabBarItem.imageInsets = UIEdgeInsetsMake( 0, 10, 0, -10);
        
        let viewControllerList = [feedController,
                                  galleryController,
                                  itemsItem,
                                  settingsItem,
                                  cartItem]
        
        viewControllers = viewControllerList
    }
}


