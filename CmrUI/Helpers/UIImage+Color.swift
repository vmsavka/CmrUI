//
//  UIImage+Color.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/20/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

extension UIImage {
    // Create a 1x1 image with this color
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
