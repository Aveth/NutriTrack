//
//  Food.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class Food {
    
    internal var id: String
    internal var name: String
    internal var category: String
    internal var nutrients: [Nutrient]
    internal var measures: [Measure]
    
    lazy private(set) var sortedNutrients: [Nutrient] = {
        return self.nutrients.sort() { $0.name.compare($1.name) == .OrderedAscending }
    }()
    
    lazy private(set) var sortedMeasures: [Measure] = {
        return self.measures.sort() { $0.index < $1.index }
    }()
    
    internal init(id: String, name: String, category: String) {
        self.id = id
        self.name = name
        self.category = category
        self.nutrients = [Nutrient]()
        self.measures = [Measure]()
    }

}
