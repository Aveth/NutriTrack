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
            success: { (result) -> Void in
                
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
            failure: failure
        )
        
    }
    
    internal func fetchFoodDetails(id: String, diet: Nutrient.Diet, success: ((result: Food) -> Void), failure:((error: ErrorType) -> Void)?) {
        
        self.service.fetchDetails(itemId: id,
            success: { (result) -> Void in
                if let
                    dict = result["data"] as? [AnyObject],
                    firstResult = dict.first,
                    resultId = firstResult["id"] as? String,
                    resultName = firstResult["name"] as? String,
                    resultCategory = firstResult["category"] as? String
                    where resultId == id
                {
                    let food = Food(id: resultId, name: resultName, category: resultCategory)
                    if let measures = firstResult["measures"] as? [[String: AnyObject]] {
                        food.measures = self.arrayToMeasureItems(measures)
                    }
                    if let nutrients = firstResult["nutrients"] as? [[String: AnyObject]] {
                        food.nutrients = self.arrayToNutrientItems(nutrients, nutrientCodes: Nutrient.Diet.Renal.nutrientCodes())
                    }
                    success(result: food)
                }
            },
            failure: failure
        )
        
    }
    
    internal func fetchCategories(success success: ((results: [Category]) -> Void), failure:((error: ErrorType) -> Void)?) {
        
        self.service.fetchCategories(
            success: { (results) in
                var result = [Category]()
                if let array = results["data"] as? [[String: String]] {
                    for dict in array {
                        if let
                            id = dict["id"],
                            name = dict["name"]
                        {
                            let item = Category(id: id, name: name)
                            result.append(item)
                        }
                    }
                    success(results: result)
                }
            },
            failure: failure
        )
        
    }
    
    private func arrayToFoods(array: [[String: AnyObject]]) -> [Food] {
        var result = [Food]()
        for dict in array {
            if let
                id = dict["id"] as? String,
                name = dict["name"] as? String,
                category = dict["category"] as? String
            {
                let item = Food(id: id, name: name, category: category)
                result.append(item)
            }
        }
        return result
    }
    
    private func arrayToMeasureItems(array: [[String: AnyObject]]) -> [Measure] {
        var result = [Measure]()
        for measure in array {
            if let
                index = measure["index"] as? Int,
                name = measure["name"] as? String,
                value = measure["value"] as? Float
            {
                let item = Measure(index: index, name: name, value: value)
                result.append(item)
            }
        }
        return result
    }
    
    private func arrayToNutrientItems(array: [[String: AnyObject]], nutrientCodes: [String]?) -> [Nutrient] {
        var result = [Nutrient]()
        for nutrient in array {
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
