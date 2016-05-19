//
//  CoreDataContextProvider.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

class DiaryManger {
    
    internal var pages: [DiaryPage]?
    internal var provider: MealsProviderProtocol
    
    internal init(provider: MealsProviderProtocol) {
        self.provider = provider
    }
    
    internal func saveMeal(meal: Meal) {
        if meal.id == nil {
            self.provider.insertMeal(meal, forUser: "", success: nil, failure: nil)
        } else {
            self.provider.updateMeal(meal, forUser: "", success: nil, failure: nil)
        }
    }
    
    internal func refresh(success success: ((results: [DiaryPage]?) -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.provider.fetchMealsForUser("", startDate: NSDate.distantPast(), endDate: NSDate().dateOnly()!.dateByAddingTimeInterval(60 * 60 * 24),
            success: { (results) in
                self.pages = self.pagesFromMeals(results)
                success(results: self.pages)
            },
            failure: failure
        )
    }
    
    internal func removeMeal(meal: Meal) {
        self.provider.deleteMeal(meal, forUser: "", success: nil, failure: nil)
    }
    
    internal func nextPageAfterPage(page: DiaryPage) -> DiaryPage? {
        guard let
            index = self.pages?.indexOf(page),
            nextPage = self.pages?[index + 1]
        else {
            return nil
        }
        
        return nextPage
    }
    
    internal func previousPageBeforePage(page: DiaryPage) -> DiaryPage? {
        guard let
            index = self.pages?.indexOf(page),
            prevPage = self.pages?[index - 1]
        else {
                return nil
        }
        
        return prevPage
    }
    
    private func pagesFromMeals(meals: [Meal]?) -> [DiaryPage]? {
        
        guard let meals = meals else {
            return nil
        }
        
        var dict = [NSDate: [Meal]]()
        for meal in meals {
            let date = meal.dateTime.dateOnly()!
            if dict[date] == nil {
                dict[date] = [Meal]()
            }
            dict[date]?.append(meal)
        }
        var results = [DiaryPage]()
        for (key, value) in dict {
            results.append(DiaryPage(date: key, meals: value))
        }
        return results
        
    }

}
