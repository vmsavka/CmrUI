//
//  UIStoryboard+Name.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/13/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import Foundation
import UIKit

@objc enum StoryboardName: Int {
    case cmrContainer
    case newsFeed
    case dashboard
    case settings
}

extension UIStoryboard {
    @objc static func storyboardWith(name: StoryboardName) -> UIStoryboard {
        var storyboardName  = ""
        switch name {
        case .cmrContainer:
            storyboardName = "CmrContainer"
        case .newsFeed:
            storyboardName = "NewsFeed"
        case .dashboard:
            storyboardName = "Dashboard"
        case .settings:
            storyboardName = "Settings"
        }
        
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
}

