//
//  UIColor+NTAppStyle.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

extension UIColor {
    
    static internal func themeBackgroundColor() -> UIColor {
        return UIColor(red: 0.0 / 255.0, green: 205.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    
    static internal func themeForegroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static internal func tabBarBackgroundColor() -> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    static internal func backgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }

    static internal func barButtonItemColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static internal func defaultTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
}
