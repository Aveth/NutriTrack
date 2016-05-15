//
//  Measure.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class Measure {

    internal var index: Int
    internal var name: String
    internal var value: Float
    
    internal init(index: Int, name: String, value: Float) {
        self.index = index
        self.name = name
        self.value = value
    }
    
}
