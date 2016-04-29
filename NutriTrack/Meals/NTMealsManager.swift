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
    
    internal init(provider: NTMealsProviderProtocol) {
        self.provider = provider
    }
    
    internal func saveMeal(meal: NTMeal) {
        if meal.id == nil {
            meal.id = NSUUID().UUIDString
            self.provider.insertMeal(meal)
        } else {
            self.provider.updateMeal(meal)
        }
    }
    
    internal func removeMeal(meal: NTMeal) {
        self.provider.deleteMeal(meal)
    }

}
