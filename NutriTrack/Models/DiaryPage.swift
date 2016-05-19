//
//  DiaryPage.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

func ==(lhs: DiaryPage, rhs: DiaryPage) -> Bool {
    return lhs.date == rhs.date
}

class DiaryPage: Equatable {

    internal var date: NSDate
    internal var meals: [Meal]
    
    internal init(date: NSDate, meals: [Meal]) {
        self.date = date
        self.meals = meals
    }
    
}
