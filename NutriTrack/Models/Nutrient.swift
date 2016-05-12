//
//  Nutrient.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class Nutrient {
    
    internal enum Diet: Int {
        case Renal
        case Diabetic
        func nutrientCodes() -> [String] {
            switch self {
                case Diabetic: return ["205", "269"]
                case Renal: return ["305", "306", "307"]
            }
        }
    }
    
    static internal let BaseMeasuresGrams: Float = 100.0

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
