//
//  UIFont+NTAppStyle.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

extension UIFont {
    
    internal static func fontOfStyle(style: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Roboto-" + style, size: size) {
            return font
        }
        return UIFont.preferredFontForTextStyle(style)
    }
    
    internal static func regularFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("Regular", size: size)
    }
    
    internal static func italicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("Italic", size: size)
    }
    
    internal static func boldItalicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("BoldItalic", size: size)
    }
    
    internal static func lightFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("Light", size: size)
    }
    
    internal static func lightItalicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("LightItalic", size: size)
    }
    
    internal static func semiBoldFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("SemiBold", size: size)
    }
    
    internal static func semiBoldItalicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("SemiBoldItalic", size: size)
    }
    
    internal static func extraLightFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("ExtraLight", size: size)
    }
    
    internal static func extraLightItalicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("ExtraLightItalic", size: size)
    }
    
    internal static func extraBoldFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("ExtraBold", size: size)
    }
    
    internal static func extraBoldItalicFontOfSize(size: CGFloat) -> UIFont {
        return self.fontOfStyle("ExtraBoldItalic", size: size)
    }
    
}
