//
//  ICMPMealItem.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-29.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class NTMealItem {

    internal var food: NTFood
    internal var measureIndex: Int
    internal var quantity: Int
    
    internal init(food: NTFood, quantity: Int, measureIndex: Int) {
        self.food = food
        self.measureIndex = measureIndex
        self.quantity = quantity
    }

    
}
