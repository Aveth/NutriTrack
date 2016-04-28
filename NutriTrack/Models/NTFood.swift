//
//  NTFood.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class NTFood {
    
    internal var id: String
    internal var name: String
    internal var nutrients: [NTNutrient]
    internal var measures: [NTMeasure]
    internal var selectedMeasure: NTMeasure?
    
    internal init(id: String, name: String) {
        self.id = id
        self.name = name
        self.nutrients = [NTNutrient]()
        self.measures = [NTMeasure]()
    }

}
