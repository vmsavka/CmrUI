//
//  CmrTabBar.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/10/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

fileprivate struct CmrTabBarColours {
    static let tabBarBackgroundColor = UIColor(red: 159.0/255.0, green: 193.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    static let tabBarSelectedItemColor = UIColor(red: 39.0/255.0, green: 42.0/255.0, blue: 45.0/255.0, alpha: 1.0)
}

fileprivate struct CmrTabBarItems {
    static let feedTabBarItem: CGFloat = 0
    static let galleryTabBarItem: CGFloat = 1
    static let itemsTabBarItem: CGFloat = 2
    static let settingsTabBarItem: CGFloat = 3
    static let cartTabBarItem: CGFloat = 4
}

fileprivate struct CmrTabBarSizes {
    static let bottomOffset: CGFloat = 40.0
    static let sideOffset: CGFloat = 24.0
    static let radiusBarItem: CGFloat = 26.0
}

class CmrTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .clear
        tabBar.barTintColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        setupAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for barItem in tabBar.items! {
            let offset = CmrTabBarSizes.bottomOffset - 4
            barItem.imageInsets = UIEdgeInsetsMake( -offset, barItem.imageInsets.left, offset, barItem.imageInsets.right);
        }
    }

    func setupAppearance() {
        let backgroundView = drawBackgroundView()
        view.addSubview(backgroundView)
        self.view.bringSubview(toFront: self.tabBar)
        
        setupControllers()
    }
    
    func drawBackgroundView () -> UIView {
        let barView = UIView.init(frame: CGRect(x: CmrTabBarSizes.sideOffset,
                                             y: CGFloat(self.view.frame.size.height) - CmrTabBarSizes.bottomOffset - 2.0 * CmrTabBarSizes.radiusBarItem,
                                             width: self.view.frame.size.width - 2 * CmrTabBarSizes.sideOffset,
                                             height: 2 * CmrTabBarSizes.radiusBarItem) )
        barView.layer.cornerRadius = CmrTabBarSizes.radiusBarItem
        barView.backgroundColor = CmrTabBarColours.tabBarBackgroundColor
        return barView
    }
}

/*
    MARK: - Navigation
*/
extension CmrTabBar {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
