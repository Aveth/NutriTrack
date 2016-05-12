//
//  MealsService.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol MealsProviderProtocol: class {

    func fetchMeals() -> [Meal]
    func fetchMealsForStartDate(startDate: NSDate, endDate: NSDate) -> [Meal]
    func insertMeal(meal: Meal)
    func updateMeal(meal: Meal)
    func deleteMeal(meal: Meal)
    
}
