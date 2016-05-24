//
//  UserProfile.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-23.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation
import CoreData

class UserProfile: UserProfileProtocol {
    
    static private let userIDKey = "UserProfile_IDKey"
    
    internal var id: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(UserProfile.userIDKey)
        }
    }
    
    private var _recentFoods: [Food]?
    internal var recentFoods: [Food]? {
        get {
            return self._recentFoods
        }
    }
    
    private var _selectedNutrients: [Nutrient]?
    internal var selectedNutrients: [Nutrient]? {
        get {
            return self._selectedNutrients
        }
    }
    
    private var managedObjectContext = CDContextProvider.sharedProvider.managedObjectContext
    private var modelAdapter = CDModelAdapter.sharedAdapter
    
    internal func refresh(success success: (() -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.fetchFoods(
            success: { (results) in
                self._recentFoods = results
            }, failure: nil
        )
    }
    
    private func fetchFoods(success success: ((results: [Food]) -> Void), failure: ((error: ErrorType) -> Void)?) {
        do {
            let request = NSFetchRequest(entityName: "CDFood")
            let foods = try self.managedObjectContext.executeFetchRequest(request) as! [CDFood]
            var results = [Food]()
            for coreDataFood in foods {
                if let food = self.modelAdapter.foodFromCoreData(coreDataFood) {
                    results.append(food)
                }
            }
            success(results: results)
        } catch let error {
            if let fail = failure {
                fail(error: error)
            }
        }
    }
    
}
