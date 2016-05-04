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
        return UIColor(colorLiteralRed: 0.0, green: 164.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    
    static internal func themeForegroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static internal func tabBarBackgroundColor() -> UIColor {
        return UIColor(colorLiteralRed: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    
    static internal func backgroundColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static internal func navigationBarColor() -> UIColor {
        return UIColor(red: 217.0 / 255.0, green: 217.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    }
    
    static internal func barButtonItemColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    static internal func pageControlBackgroundColor() -> UIColor {
        return UIColor.darkGrayColor()
    }
    
    static internal func defaultTextColor() -> UIColor {
        return UIColor.blackColor()
    }
    
}
