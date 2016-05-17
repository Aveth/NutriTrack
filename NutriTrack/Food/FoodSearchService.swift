
//
//  SearchService.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import Alamofire

class SearchService {
    
    private enum Endpoints: String {
        case FoodSearch = "/food/search"
        case FoodDetails = "/food/details"
        case Categories = "/food/categories"
    }
    
    static private let APIBaseURL: String = NSBundle.mainBundle().objectForInfoDictionaryKey("NTAPIBaseURL") as! String
    
    internal func fetchResults(searchQuery query: String, success: ((results: [String: AnyObject]) -> Void), failure: ((error: ErrorType) -> Void)?) -> Request {
        return self.fetch(.FoodSearch, urlParam: query, success:success, failure: failure)
    }
    
    internal func fetchDetails(itemId id: String, success: ((results: [String: AnyObject]) -> Void), failure: ((error: ErrorType) -> Void)?) -> Request {
        return self.fetch(.FoodDetails, urlParam: id, success: success, failure: failure)
    }
    
    internal func fetchCategories(success success: ((results: [String: AnyObject]) -> Void), failure: ((error: ErrorType) -> Void)?) -> Request {
        return self.fetch(.Categories, success: success, failure: failure)
    }
    
    private func fetch(endpoint: SearchService.Endpoints, urlParam: String? = nil, success: ((results: [String: AnyObject]) -> Void), failure: ((error: ErrorType) -> Void)?) -> Request {
        
        var url: String;
        if let param = urlParam?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) {
            url = SearchService.APIBaseURL + endpoint.rawValue + "/" + param
        } else {
            url = SearchService.APIBaseURL + endpoint.rawValue
        }
        
        return Alamofire.request(Method.GET, url).responseJSON() { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
                
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
    
    
}
