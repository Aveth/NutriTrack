//
//  NTFoodItem.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTFoodItem {

    internal var id: String
    internal var name: String
    internal var measures: [NTMeasure]
    internal var nutrients: [NTNutrient]
    
    internal init(id: String, name: String) {
        self.id = id
        self.name = name
        self.measures = [NTMeasure]()
        self.nutrients = [NTNutrient]()
    }
    
}
