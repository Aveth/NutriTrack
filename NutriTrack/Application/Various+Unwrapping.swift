//
//  AnyObject+Unwrapping.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

extension String {
    static internal func unwrapOrBlank(wrapped: String?) -> String {
        if let unwrapped = wrapped {
            return unwrapped
        }
        return ""
    }
}

extension Int {
    static internal func unwrapOrZero(wrapped: Int?) -> Int {
        if let unwrapped = wrapped {
            return unwrapped
        }
        return 0
    }
}

extension Float {
    static internal func unwrapOrZero(wrapped: Float?) -> Float {
        if let unwrapped = wrapped {
            return unwrapped
        }
        return 0.0
    }
}