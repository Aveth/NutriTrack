//
//  MealsService.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol MealsProviderProtocol: class {

    func fetchFirstValidDateForUser(id: String, success: ((result: NSDate?) -> Void), failure: ((error: ErrorType) -> Void)?)
    func fetchMealsForUser(id: String, startDate: NSDate, endDate: NSDate, success: ((results: [Meal]?) -> Void), failure: ((error: ErrorType) -> Void)?)
    func insertMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?)
    func updateMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?)
    func deleteMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?)
    
}
