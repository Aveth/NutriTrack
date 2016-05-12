//
//  Meal.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class Meal {
    
    internal var id: String?
    internal var dateTime: NSDate
    internal var mealItems: [MealItem]
    
    internal init(dateTime: NSDate) {
        self.dateTime = dateTime
        self.mealItems = [MealItem]()
    }
    
    convenience internal init(id: String, dateTime: NSDate) {
        self.init(dateTime: dateTime)
        self.id = id
    }

}
