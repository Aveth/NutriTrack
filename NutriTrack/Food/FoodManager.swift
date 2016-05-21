//
//  SearchProvider.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

class FoodManager {

    internal var categories: [Category]?
    internal var nutrients: [Nutrient]?
    internal var recentFoods: [Food]?
    internal var provider: FoodProviderProtocol
    
    init(provider: FoodProviderProtocol) {
        self.provider = provider
    }
    
    internal func search(query: String, success: ((originalQuery: String, results: [Food]) -> Void), failure:((error: ErrorType) -> Void)?) {
        self.provider.findFoodsForSearchQuery(query, success: success, failure: failure)
    }
    
    internal func detailsForFood(id: String, diet: Nutrient.Diet, success: ((result: Food) -> Void), failure:((error: ErrorType) -> Void)?) {
        self.provider.fetchFoodDetailsWithID(id, success: success, failure: failure)
    }
    
    internal func refresh() {
        
        let refreshGroup = dispatch_group_create()
        
        dispatch_group_enter(refreshGroup)
        self.provider.fetchCategories(
            success: { (results) in
                self.categories = results
                dispatch_group_leave(refreshGroup)
            },
            failure: { (error) in
                dispatch_group_leave(refreshGroup)
            }
        )
        
        dispatch_group_enter(refreshGroup)
        self.provider.fetchNutrients(
            success: { (results) in
                self.nutrients = results
                dispatch_group_leave(refreshGroup)
            },
            failure: { (error) in
                dispatch_group_leave(refreshGroup)
            }
        )
        
    }
    
    internal func fetchCategories(success success: ((results: [Category]) -> Void), failure:((error: ErrorType) -> Void)?) {
        
        self.provider.fetchCategories(
            success: { (results) in
                
            },
            failure: failure
        )
        
    }
    
    
    

}
