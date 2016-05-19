//
//  FoodSearchProviderProtocol.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol FoodProviderProtocol: class {

    func findFoodsForSearchQuery(query: String, success: ((originalQuery: String, results: [Food]) -> Void), failure: ((error: ErrorType) -> Void)?)
    func fetchFoodDetailsWithID(id: String, success: ((result: Food) -> Void), failure: ((error: ErrorType) -> Void)?)
    func fetchRecentFoodsForUser(id: String, success: ((result: [Food]) -> Void), failure: ((error: ErrorType) ->Void)?)

}
