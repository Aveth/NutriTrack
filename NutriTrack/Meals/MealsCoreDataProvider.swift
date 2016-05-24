//
//  MealsCoreDataServiceProvider+PublicInterface.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation
import CoreData

class MealsCoreDataProvider: MealsProviderProtocol {
    
    private var managedObjectContext = CDContextProvider.sharedProvider.managedObjectContext
    private var modelAdapter = CDModelAdapter.sharedAdapter
    
    internal func fetchFirstValidDateForUser(id: String, success: ((result: NSDate?) -> Void), failure: ((error: ErrorType) -> Void)?) {
        do {
            let request = NSFetchRequest(entityName: "CDMeal")
            request.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
            request.fetchLimit = 1
            let meals = try self.managedObjectContext.executeFetchRequest(request) as! [CDMeal]
            success(result: meals.first?.dateTime)
        } catch let error {
            if let fail = failure {
                fail(error: error)
            }
        }
    }
    
    internal func fetchMealsForUser(id: String, startDate: NSDate, endDate: NSDate, success: ((results: [Meal]?) -> Void), failure: ((error: ErrorType) -> Void)?) {
        do {
            let predicate = NSPredicate(format: "dateTime >= %@ AND dateTime < %@", startDate, endDate)
            let results = try self.fetchMealsWithPredicate(predicate)
            success(results: results)
        } catch let error {
            if let fail = failure {
                fail(error: error)
            }
        }
    }
    
    internal func insertMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?) {
        let coreDataMeal = self.insertNewMeal(NSUUID().UUIDString, dateTime: meal.dateTime)
        for item: MealItem in meal.mealItems {
            if self.fetchFoodByID(item.food.id) == nil {
                let coreDataFood = self.insertNewFood(item.food.id, name: item.food.name, category: item.food.category)
                for nutrient: Nutrient in item.food.nutrients {
                    let coreDataNutrient = self.insertNewNutrient(nutrient.id, name: nutrient.name, unit: nutrient.unit, value: nutrient.value)
                    coreDataFood.addNutrientsObject(coreDataNutrient)
                }
                for measure: Measure in item.food.measures {
                    let coreDataMeasure = self.insertNewMeasure(measure.index, name: measure.name, value: measure.value)
                    coreDataFood.addMeasuresObject(coreDataMeasure)
                }
                self.managedObjectContext.insertObject(coreDataFood)
            }
            let coreDataMealItem = self.insertNewMealItem(item.food.id, quantity: item.quantity, measureIndex: item.measureIndex)
            coreDataMeal.addMealItemsObject(coreDataMealItem)
            
        }
        
        self.managedObjectContext.insertObject(coreDataMeal)
        self.saveContext()
        
    }
    
    internal func updateMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?) {
        //code
    }
    
    internal func deleteMeal(meal: Meal, forUser id: String, success: (() -> Void)?, failure: ((error: ErrorType) -> Void)?) {
        //code
    }
    
    private func fetchFoodByID(id: String) -> CDFood? {
        let predicate = NSPredicate(format: "id = %@", id)
        let request = NSFetchRequest(entityName: "CDFood")
        request.predicate = predicate
        do {
            let foods = try self.managedObjectContext.executeFetchRequest(request) as! [CDFood]
            return foods.first
        } catch {
            return nil
        }
    }
    
    private func fetchMealsWithPredicate(predicate: NSPredicate?) throws -> [Meal] {
        var resultMeals = [Meal]()
        do {
            let request = NSFetchRequest(entityName: "CDMeal")
            request.predicate = predicate
            let meals = try self.managedObjectContext.executeFetchRequest(request) as! [CDMeal]
            for meal: CDMeal in meals {
                if let
                    id = meal.id,
                    dateTime = meal.dateTime,
                    mealItems = meal.mealItems?.allObjects as? [CDMealItem]
                {
                    let resultMeal = Meal(id: id, dateTime: dateTime)
                    resultMeals.append(resultMeal)
                    for item: CDMealItem in mealItems {
                        if let
                            foodId = item.foodID,
                            food = self.fetchFoodByID(foodId),
                            result = self.modelAdapter.mealItemFromCoreData(item, coreDataFood: food)
                        {
                            resultMeal.mealItems.append(result)
                        }
                    }
                }
                
            }
        } catch let error {
            throw error
        }
        
        return resultMeals
    }
    
    private func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("\(error)")
        }
    }
    
    private func insertNewMeal(id: String, dateTime: NSDate) -> CDMeal {
        let item: CDMeal = NSEntityDescription.insertNewObjectForEntityForName("CDMeal", inManagedObjectContext: self.managedObjectContext) as! CDMeal
        item.id = id
        item.dateTime = dateTime
        return item
    }
    
    private func insertNewMealItem(foodID: String, quantity: Int, measureIndex: Int) -> CDMealItem {
        let item: CDMealItem = NSEntityDescription.insertNewObjectForEntityForName("CDMealItem", inManagedObjectContext: self.managedObjectContext) as! CDMealItem
        item.foodID = foodID
        item.quantity = quantity
        item.measureIndex = measureIndex
        return item
    }
    
    private func insertNewFood(id: String, name: String, category: String) -> CDFood {
        let item: CDFood = NSEntityDescription.insertNewObjectForEntityForName("CDFood", inManagedObjectContext: self.managedObjectContext) as! CDFood
        item.id = id
        item.name = name
        item.category = category
        return item
    }
    
    private func insertNewNutrient(id: String, name: String, unit: String, value: Float) -> CDNutrient {
        let item: CDNutrient = NSEntityDescription.insertNewObjectForEntityForName("CDNutrient", inManagedObjectContext: self.managedObjectContext) as! CDNutrient
        item.id = id
        item.name = name
        item.unit = unit
        item.value = value
        return item
    }
    
    private func insertNewMeasure(index: Int, name: String, value: Float) -> CDMeasure {
        let item: CDMeasure = NSEntityDescription.insertNewObjectForEntityForName("CDMeasure", inManagedObjectContext: self.managedObjectContext) as! CDMeasure
        item.index = index
        item.name = name
        item.value = value
        return item
    }

}
