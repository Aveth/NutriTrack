//
//  NTMealsCoreDataServiceProvider+PublicInterface.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation
import CoreData

class NTMealsCoreDataProvider: NTMealsProviderProtocol {
    
    static private let errorDomain: String = "com.aveth.NutriTrack.NTCoreDataContextProvider"
    
    lazy private var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
    
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("NutriTrack.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: NTMealsCoreDataProvider.errorDomain, code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("NutriTrack", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy internal var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    internal func fetchMeals() -> [NTMeal] {
        return self.fetchMealsWithPredicate(nil)
    }
    
    func fetchMealsForStartDate(startDate: NSDate, endDate: NSDate) -> [NTMeal] {
        let predicate = NSPredicate(format: "dateTime >= %@ AND dateTime < %@", startDate, endDate)
        return self.fetchMealsWithPredicate(predicate)
    }
    
    private func fetchMealsWithPredicate(predicate: NSPredicate?) -> [NTMeal] {
        var resultMeals = [NTMeal]()
        do {
            let request = NSFetchRequest(entityName: "NTCDMeal")
            request.predicate = predicate
            let meals = try self.managedObjectContext.executeFetchRequest(request) as! [NTCDMeal]
            for meal: NTCDMeal in meals {
                if let
                    id = meal.id,
                    dateTime = meal.dateTime,
                    mealItems = meal.mealItems?.allObjects as? [NTCDMealItem]
                {
                    let resultMeal = NTMeal(id: id, dateTime: dateTime)
                    resultMeals.append(resultMeal)
                    for item: NTCDMealItem in mealItems {
                        if let result = self.mealItemFromCoreData(item) {
                            resultMeal.mealItems.append(result)
                        }
                    }
                }
                
            }
        } catch let error {
            print("\(error)")
        }
        
        return resultMeals
    }
    
    internal func insertMeal(meal: NTMeal) {
        let coreDataMeal = self.insertNewMeal(NSUUID().UUIDString, dateTime: meal.dateTime)
        for item: NTMealItem in meal.mealItems {
            if self.fetchFoodByID(item.food.id) == nil {
                let coreDataFood = self.insertNewFood(item.food.id, name: item.food.name)
                for nutrient: NTNutrient in item.food.nutrients {
                    let coreDataNutrient = self.insertNewNutrient(nutrient.id, name: nutrient.name, unit: nutrient.unit, value: nutrient.value)
                    coreDataFood.addNutrientsObject(coreDataNutrient)
                }
                for measure: NTMeasure in item.food.measures {
                    let coreDataMeasure = self.insertNewMeasure(measure.name, value: measure.value)
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
    
    internal func fetchFoodByID(id: String) -> NTCDFood? {
        let predicate = NSPredicate(format: "id = %@", id)
        let request = NSFetchRequest(entityName: "NTCDFood")
        request.predicate = predicate
        do {
            let foods =  try self.managedObjectContext.executeFetchRequest(request) as!     [NTCDFood]
            return foods.first
        } catch {
            return nil
        }
    }
    
    internal func updateMeal(meal: NTMeal) {
        //code
    }
    
    internal func deleteMeal(meal: NTMeal) {
        //self.managedObjectContext.deleteObject(meal)
    }
    
    private func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("\(error)")
        }
    }
    
    private func mealItemFromCoreData(coreDataMealItem: NTCDMealItem?) -> NTMealItem? {
        if let
            measureIndex = coreDataMealItem?.measureIndex,
            quantity = coreDataMealItem?.quantity,
            foodID = coreDataMealItem?.foodID
        {
            if let
                coreDataFood = self.fetchFoodByID(foodID),
                resultFood = self.foodFromCoreData(coreDataFood)
            {
                let resultMealItem = NTMealItem(food: resultFood, quantity: quantity.integerValue, measureIndex: measureIndex.integerValue)
                return resultMealItem
            }
        }
        return nil
    }
    
    private func foodFromCoreData(coreDataFood: NTCDFood?) -> NTFood? {
        if let
            id = coreDataFood?.id,
            name = coreDataFood?.name,
            nutrients = coreDataFood?.nutrients?.allObjects as? [NTCDNutrient],
            measures = coreDataFood?.measures?.allObjects as? [NTCDMeasure]
        {
            let resultFood = NTFood(id: id, name: name)
            for nutrient: NTCDNutrient in nutrients {
                if let result = self.nutrientFromCoreData(nutrient) {
                    resultFood.nutrients.append(result)
                }
            }
            for measure: NTCDMeasure in measures {
                if let result = self.measureFromCoreData(measure) {
                    resultFood.measures.append(result)
                }
            }
            return resultFood
        }
        return nil
    }
    
    private func nutrientFromCoreData(coreDataNutrient: NTCDNutrient?) -> NTNutrient? {
        if let
            id = coreDataNutrient?.id,
            name = coreDataNutrient?.name,
            unit = coreDataNutrient?.unit,
            value = coreDataNutrient?.value
        {
            return NTNutrient(id: id, name: name, unit: unit, value: value.floatValue)
        }
        return nil
    }
    
    private func measureFromCoreData(coreDataMeasure: NTCDMeasure?) -> NTMeasure? {
        if let
            name = coreDataMeasure?.name,
            value = coreDataMeasure?.value
        {
            return NTMeasure(name: name, value: value.floatValue)
        }
        return nil
    }
    
    private func insertNewMeal(id: String, dateTime: NSDate) -> NTCDMeal {
        let item: NTCDMeal = NSEntityDescription.insertNewObjectForEntityForName("NTCDMeal", inManagedObjectContext: self.managedObjectContext) as! NTCDMeal
        item.id = id
        item.dateTime = dateTime
        return item
    }
    
    private func insertNewMealItem(foodID: String, quantity: Int, measureIndex: Int) -> NTCDMealItem {
        let item: NTCDMealItem = NSEntityDescription.insertNewObjectForEntityForName("NTCDMealItem", inManagedObjectContext: self.managedObjectContext) as! NTCDMealItem
        item.foodID = foodID
        item.quantity = quantity
        item.measureIndex = measureIndex
        return item
    }
    
    private func insertNewFood(id: String, name: String) -> NTCDFood {
        let item: NTCDFood = NSEntityDescription.insertNewObjectForEntityForName("NTCDFood", inManagedObjectContext: self.managedObjectContext) as! NTCDFood
        item.id = id
        item.name = name
        return item
    }
    
    private func insertNewNutrient(id: String, name: String, unit: String, value: Float) -> NTCDNutrient {
        let item: NTCDNutrient = NSEntityDescription.insertNewObjectForEntityForName("NTCDNutrient", inManagedObjectContext: self.managedObjectContext) as! NTCDNutrient
        item.id = id
        item.name = name
        item.unit = unit
        item.value = value
        return item
    }
    
    private func insertNewMeasure(name: String, value: Float) -> NTCDMeasure {
        let item: NTCDMeasure = NSEntityDescription.insertNewObjectForEntityForName("NTCDMeasure", inManagedObjectContext: self.managedObjectContext) as! NTCDMeasure
        item.name = name
        item.value = value
        return item
    }

}
