//
//  NTMeal.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

class NTMeal {
    
    internal var id: String?
    internal var dateTime: NSDate
    internal var mealItems: [NTMealItem]
    
    internal init(dateTime: NSDate) {
        self.dateTime = dateTime
        self.mealItems = [NTMealItem]()
    }
    
    convenience internal init(id: String, dateTime: NSDate) {
        self.init(dateTime: dateTime)
        self.id = id
    }

}
