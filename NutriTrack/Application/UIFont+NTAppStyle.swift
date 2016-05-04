//
//  UIFont+NTAppStyle.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

extension UIFont {
    
    static internal func fontOfStyle(style: String, size: Float) -> UIFont {
        if let font = UIFont(name: "Roboto-" + style, size: CGFloat(size)) {
            return font
        }
        return UIFont.preferredFontForTextStyle(style).fontWithSize(CGFloat(size))
    }
    
    static internal func regularFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("Regular", size: size)
    }
    
    static internal func italicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("Italic", size: size)
    }
    
    static internal func boldFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("Bold", size: size)
    }
    
    static internal func boldItalicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("BoldItalic", size: size)
    }
    
    static internal func lightFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("Light", size: size)
    }
    
    static internal func lightItalicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("LightItalic", size: size)
    }
    
    static internal func semiBoldFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("SemiBold", size: size)
    }
    
    static internal func semiBoldItalicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("SemiBoldItalic", size: size)
    }
    
    static internal func extraLightFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("ExtraLight", size: size)
    }
    
    static internal func extraLightItalicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("ExtraLightItalic", size: size)
    }
    
    static internal func extraBoldFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("ExtraBold", size: size)
    }
    
    static internal func extraBoldItalicFontOfSize(size: Float) -> UIFont {
        return self.fontOfStyle("ExtraBoldItalic", size: size)
    }
    
    static internal func defaultFont() -> UIFont {
        return self.regularFontOfSize(14.0)
    }
    
}
