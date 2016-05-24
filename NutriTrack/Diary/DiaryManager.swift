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
    
    lazy private(set) var sortedPages: [DiaryPage]? = {
        return self.pages?.sort() { $0.date.compare($1.date) == .OrderedAscending }
    }()
    
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
    
    internal func refresh(success success: (() -> Void), failure: ((error: ErrorType) -> Void)?) {
        self.provider.fetchMealsForUser("", startDate: NSDate.distantPast(), endDate: NSDate().dateOnly()!.dateByAddingTimeInterval(60 * 60 * 24),
            success: { (results) in
                self.pages = self.pagesFromMeals(results)
                success()
            },
            failure: failure
        )
    }
    
    internal func removeMeal(meal: Meal) {
        self.provider.deleteMeal(meal, forUser: "", success: nil, failure: nil)
    }
    
    internal func nextPageAfterPage(page: DiaryPage) -> DiaryPage? {
        guard let
            pages = self.sortedPages,
            index = pages.indexOf(page)
        where index < pages.count - 1
        else {
            return nil
        }
        
        return pages[index + 1]
    }
    
    internal func previousPageBeforePage(page: DiaryPage) -> DiaryPage? {
        guard let index = self.sortedPages?.indexOf(page)
        where index > 0
        else {
            return nil
        }
        
        return self.sortedPages?[index - 1]
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
