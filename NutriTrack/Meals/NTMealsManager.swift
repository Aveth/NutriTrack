//
//  NTCoreDataContextProvider.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

class NTMealsManger {
    
    internal var provider: NTMealsProviderProtocol
    
    private(set) lazy var meals: [NTMeal] = {
        let meals = self.provider.fetchMeals()
        return meals
    }()
    
    private(set) lazy var mealsForToday: [NTMeal] = {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: NSDate())
        let startDate = calendar.dateFromComponents(components)
        components.day += 1
        let endDate = calendar.dateFromComponents(components)
        let meals = self.provider.fetchMealsForStartDate(startDate!, endDate: endDate!)
        return meals
    }()
    
    internal init(provider: NTMealsProviderProtocol) {
        self.provider = provider
    }
    
    internal func saveMeal(meal: NTMeal) {
        if meal.id == nil {
            self.provider.insertMeal(meal)
        } else {
            self.provider.updateMeal(meal)
        }
    }
    
    internal func removeMeal(meal: NTMeal) {
        self.provider.deleteMeal(meal)
    }

}
