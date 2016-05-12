//
//  CoreDataContextProvider.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

class MealsManger {
    
    internal var provider: MealsProviderProtocol
    
    internal var meals: [Meal] {
        get {
            let meals = self.provider.fetchMeals()
            return meals
        }
    }
    
    internal init(provider: MealsProviderProtocol) {
        self.provider = provider
    }
    
    internal func saveMeal(meal: Meal) {
        if meal.id == nil {
            self.provider.insertMeal(meal)
        } else {
            self.provider.updateMeal(meal)
        }
    }
    
    internal func removeMeal(meal: Meal) {
        self.provider.deleteMeal(meal)
    }
    
    internal func mealsForToday() -> [Meal]? {
        let meals = self.mealsForDate(NSDate())
        guard meals.count > 0 else {
            return nil
        }
        return meals
    }
    
    internal func mealsForDate(date: NSDate) -> [Meal] {
        return self.mealsForDate(date, withOffset: 0)
    }
    
    internal func mealsForFirstDateBeforeDate(date: NSDate) -> [Meal]? {
        let meals = self.provider.fetchMealsForStartDate(NSDate.distantPast(), endDate: date)
        guard let meal = meals.last else {
            return nil
        }
        return self.mealsForDate(meal.dateTime.dateOnly()!)
    }
    
    internal func mealsForFirstDateAfterDate(date: NSDate) -> [Meal]? {
        let date = date.dateByAddingTimeInterval(60 * 60 * 24)
        let meals = self.provider.fetchMealsForStartDate(date, endDate: NSDate.distantFuture())
        guard let meal = meals.last else {
            return nil
        }
        return self.mealsForDate(meal.dateTime.dateOnly()!)
    }
    
    internal func mealsForDate(date: NSDate, withOffset offset: Int) -> [Meal] {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        components.day += offset
        let startDate = calendar.dateFromComponents(components)
        components.day += 1
        let endDate = calendar.dateFromComponents(components)
        let meals = self.provider.fetchMealsForStartDate(startDate!, endDate: endDate!)
        return meals
    }

}
