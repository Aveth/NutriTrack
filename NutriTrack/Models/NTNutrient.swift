//
//  NTNutrient.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTNutrient {

    internal var id: String
    internal var name: String
    internal var unit: String
    internal var value: Float
    
    internal init(id: String, name: String, unit: String, value: Float) {
        self.id = id
        self.name = name
        self.unit = unit
        self.value = value
    }

}
