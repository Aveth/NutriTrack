//
//  SearchProvider.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

class SearchProvider {
    
    private enum Error: Int {
        case None
        case NoResults
        case ParsingError
        case ServerError
    }

    internal var service: SearchService
    
    private let errorDomain: String = "com.aveth.NutriTrack.SearchProvider"
    
    lazy private var managedObjectContext: NSManagedObjectContext = {
        return CDContextProvider.sharedProvider.managedObjectContext
    }()
    
    init(service: SearchService) {
        self.service = service
    }
    
    internal func fetchFoods(query: String, success: ((originalQuery: String, results: [Food]) -> Void), failure:((error: ErrorType) -> Void)?) {
        
        self.service.fetchResults(searchQuery: query,
            success: { (result: [String: AnyObject]) -> Void in
                
                if let
                    resultsDict = result["data"]?["results"] as? [[String: AnyObject]],
                    originalQuery = result["data"]?["query"] as? String
                {
                    let foods = self.arrayToFoods(resultsDict)
                    success(originalQuery: originalQuery, results: foods)
                
                } else if let errCode = result["errors"]?["code"] as? String where errCode == "err_no_results" {
                    
                    if let fail = failure {
                        let error: NSError = NSError(domain: self.errorDomain, code: SearchProvider.Error.NoResults.rawValue, userInfo: nil)
                        fail(error: error)
                    }
                
                } else {
                    
                    if let fail = failure {
                        let error: NSError = NSError(domain: self.errorDomain, code: SearchProvider.Error.ParsingError.rawValue, userInfo: nil)
                        fail(error: error)
                    }
                
                }
                
            },
            failure: { (error: ErrorType) -> Void in
                if let fail = failure {
                    fail(error: error)
                }
            }
        )
        
    }
    
    internal func fetchFoodDetails(id: String, diet: Nutrient.Diet, success: ((result: Food) -> Void), failure:((error: ErrorType) -> Void)?) {
        
        self.service.fetchDetails(itemId: id,
            success: { (result: [String: AnyObject]) -> Void in
                if let
                    dict = result["data"] as? [AnyObject],
                    firstResult = dict.first,
                    resultId = firstResult["id"] as? String,
                    resultName = firstResult["name"] as? String
                    where resultId == id
                {
                    let food = Food(id: resultId, name: resultName)
                    if let measures = firstResult["measures"] as? [[String: AnyObject]] {
                        food.measures = self.arrayToMeasureItems(measures)
                    }
                    if let nutrients = firstResult["nutrients"] as? [[String: AnyObject]] {
                        food.nutrients = self.arrayToNutrientItems(nutrients, nutrientCodes: Nutrient.Diet.Renal.nutrientCodes())
                    }
                    success(result: food)
                }
            },
            failure: { (error: ErrorType) -> Void in
                
            }
        )
        
    }
    
    private func arrayToFoods(array: [[String: AnyObject]]) -> [Food] {
        var result = [Food]()
        for dict: [String: AnyObject] in array {
            if let
                id = dict["id"] as? String,
                name = dict["name"] as? String
            {
                let item = Food(id: id, name: name)
                result.append(item)
            }
        }
        return result
    }
    
    private func arrayToMeasureItems(array: [[String: AnyObject]]) -> [Measure] {
        var result = [Measure]()
        for measure: [String: AnyObject] in array {
            if let
                name = measure["name"] as? String,
                value = measure["value"] as? Float
            {
                let item = Measure(name: name, value: value)
                result.append(item)
            }
        }
        return result
    }
    
    private func arrayToNutrientItems(array: [[String: AnyObject]], nutrientCodes: [String]?) -> [Nutrient] {
        var result = [Nutrient]()
        for nutrient: [String: AnyObject] in array {
            if let
                id = nutrient["id"] as? String,
                name = nutrient["name"] as? String,
                unit = nutrient["unit"] as? String,
                value = nutrient["value"] as? String,
                floatVal = Float(value)
            {
                let item = Nutrient(id: id, name: name, unit: unit, value: floatVal)
                if let codes = nutrientCodes {
                    if codes.contains(id) {
                        result.append(item)
                    }
                } else {
                    result.append(item)
                }
                
            }
        }
        return result
    }
    

}
