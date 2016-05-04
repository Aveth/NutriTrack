//
//  NTMealsService.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol NTMealsProviderProtocol: class {

    func fetchMeals() -> [NTMeal]
    func fetchMealsForStartDate(startDate: NSDate, endDate: NSDate) -> [NTMeal]
    func insertMeal(meal: NTMeal)
    func updateMeal(meal: NTMeal)
    func deleteMeal(meal: NTMeal)
    
}
