
//
//  SearchService.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class FoodProvider: FoodProviderProtocol {
    
    internal enum Error: ErrorType {
        case None
        case NoResults
        case ParsingError
        case ServerError
        case MalformedURL
    }
    
    private enum Endpoints: String {
        case FoodSearch = "/food/search"
        case FoodDetails = "/food/details"
        case Categories = "/food/categories"
        case Nutrients = "/food/nutrients"
    }
    
    static private let APIBaseURL: String = NSBundle.mainBundle().objectForInfoDictionaryKey("NTAPIBaseURL") as! String
    
    private func preparedSearchResults(results: [String: AnyObject], success: ((originalQuery: String, results: [Food]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        if let errCode = results["errors"]?["code"] as? String
            where errCode == "err_no_results" {
            if let fail = failure {
                fail(error: FoodProvider.Error.NoResults)
            }
            return
        }
        
        guard let
            resultsDict = results["data"]?["results"] as? [[String: AnyObject]],
            originalQuery = results["data"]?["query"] as? String
            else {
                if let fail = failure {
                    fail(error: FoodProvider.Error.ParsingError)
                }
                return
        }
        
        let foods = self.arrayToFoods(resultsDict)
        success(originalQuery: originalQuery, results: foods)
    }
    
    internal func findFoodsForSearchQuery(query: String, success: ((originalQuery: String, results: [Food]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetch(.FoodSearch, urlParam: query,
            success: { (results) in
                self.preparedSearchResults(results, success: success, failure: failure)
            },
            failure: failure
        )
    }
    
    internal func fetchFoodsForCategory(category: String, success: ((originalCategory: String, results: [Food]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetch(.FoodSearch, queryParams: ["category": category],
            success: { (results) in
               self.preparedSearchResults(results, success: success, failure: failure)
            },
            failure: failure
        )
    }
    
    internal func fetchFoodDetailsWithID(id: String, success: ((result: Food) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetch(.FoodDetails, urlParam: id,
            success: { (results) in
                if let
                    dict = results["data"] as? [AnyObject],
                    firstResult = dict.first,
                    resultId = firstResult["id"] as? String,
                    resultName = firstResult["name"] as? String,
                    resultCategory = firstResult["category"] as? String
                where
                    resultId == id
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
    
    internal func fetchCategories(success success: ((results: [Category]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetch(.Categories,
            success: { (results) in
                var result = [Category]()
                guard let array = results["data"] as? [[String: String]]
                else {
                    guard let fail = failure
                    else {
                        return
                    }
                    fail(error: FoodProvider.Error.NoResults)
                    return
                }
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
            },
            failure: failure
        )
    }
    
    internal func fetchNutrients(success success: ((results: [Nutrient]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetch(.Nutrients,
            success: { (results) in
                var result = [Nutrient]()
                guard let array = results["data"] as? [[String: String]]
                    else {
                        guard let fail = failure
                            else {
                                return
                        }
                        fail(error: FoodProvider.Error.NoResults)
                        return
                }
                for dict in array {
                    if let
                        id = dict["id"],
                        name = dict["name"],
                        unit = dict["unit"]
                    {
                        let item = Nutrient(id: id, name: name, unit: unit)
                        result.append(item)
                    }
                }
                success(results: result)
            },
            failure: failure
        )
    }
    
    private func fetch(endpoint: FoodProvider.Endpoints, urlParam: String? = nil, queryParams: [String: String]? = nil, success: ((results: [String: AnyObject]) -> Void), failure: ((error: ErrorType) -> Void)?) -> Request? {
        
        var url: String;
        if let param = urlParam?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) {
            url = FoodProvider.APIBaseURL + endpoint.rawValue + "/" + param
        } else {
            url = FoodProvider.APIBaseURL + endpoint.rawValue
        }
        
        guard let
            components = NSURLComponents(string: url)
        else {
            if let fail = failure {
                fail(error: FoodProvider.Error.MalformedURL)
            }
            return nil
        }
        
        if let params = queryParams {
            var queryItems = [NSURLQueryItem]()
            for (key, value) in params {
                queryItems.append(NSURLQueryItem(name: key, value: value))
            }
            components.queryItems = queryItems
        }
        
        return Alamofire.request(Method.GET, components.URLString).responseJSON() { (request, response, result) in
            switch result {
                case .Success(let data):
                    if let dataDict = data as? [String: AnyObject] {
                        success(results: dataDict)
                    }
                break
                case .Failure(_, let error):
                    if let fail = failure {
                        fail(error: error)
                    }
                break
            }
            
        }
    
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
                id = nutrient["id"] as? NSNumber,
                name = nutrient["name"] as? String,
                unit = nutrient["unit"] as? String,
                value = nutrient["value"] as? Float
            {
                let item = Nutrient(id: id.stringValue, name: name, unit: unit, value: value)
                if let codes = nutrientCodes {
                    if codes.contains(id.stringValue) {
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
