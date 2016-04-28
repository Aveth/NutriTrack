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
        
        var resultMeals = [NTMeal]()
        
        do {
            let request = NSFetchRequest(entityName: "NTCDMeal")
            let meals = try self.managedObjectContext.executeFetchRequest(request) as! [NTCDMeal]
            for meal: NTCDMeal in meals {
                if let dateTime = meal.dateTime, foods = meal.foods?.allObjects as? [NTCDFood] {
                    let resultMeal = NTMeal(dateTime: dateTime)
                    resultMeals.append(resultMeal)
                    for food: NTCDFood in foods {
                        if let result = self.foodFromCoreData(food) {
                            resultMeal.foods.append(result)
                        }
                    }
                }
                
            }
        } catch let error {
            print("\(error)")
        }
        
        return resultMeals
    }
    
    internal func saveMeal(meal: NTMeal) {
        let coreDataMeal = self.insertNewMeal(meal.dateTime)
        print("\(coreDataMeal.objectID)")
        for food: NTFood in meal.foods {
            let coreDataFood = self.insertNewFood(food.id, name: food.name)
            if let name = food.selectedMeasure?.name, value = food.selectedMeasure?.value {
                coreDataFood.selectedMeasure = self.insertNewMeasure(name, value: value)
            }
            coreDataMeal.addFoodsObject(coreDataFood)
            for nutrient: NTNutrient in food.nutrients {
                let coreDataNutrient = self.insertNewNutrient(nutrient.id, name: nutrient.name, unit: nutrient.unit, value: nutrient.value)
                coreDataFood.addNutrientsObject(coreDataNutrient)
            }
            for measure: NTMeasure in food.measures {
                let coreDataMeasure = self.insertNewMeasure(measure.name, value: measure.value)
                coreDataFood.addMeasuresObject(coreDataMeasure)
            }
        }
        
        self.managedObjectContext.insertObject(coreDataMeal)
        self.saveContext()
        
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
    
    private func foodFromCoreData(coreDataFood: NTCDFood?) -> NTFood? {
        if let id = coreDataFood?.id, name = coreDataFood?.name, nutrients = coreDataFood?.nutrients?.allObjects as? [NTCDNutrient], measures = coreDataFood?.measures?.allObjects as? [NTCDMeasure] {
            let resultFood = NTFood(id: id, name: name)
            resultFood.selectedMeasure = self.measureFromCoreData(coreDataFood?.selectedMeasure)
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
        if let id = coreDataNutrient?.id, name = coreDataNutrient?.name, unit = coreDataNutrient?.unit, value = coreDataNutrient?.value {
            return NTNutrient(id: id, name: name, unit: unit, value: value.floatValue)
        }
        return nil
    }
    
    private func measureFromCoreData(coreDataMeasure: NTCDMeasure?) -> NTMeasure? {
        if let name = coreDataMeasure?.name, value = coreDataMeasure?.value {
            return NTMeasure(name: name, value: value.floatValue)
        }
        return nil
    }
    
    private func insertNewMeal(dateTime: NSDate) -> NTCDMeal {
        let item: NTCDMeal = NSEntityDescription.insertNewObjectForEntityForName("NTCDMeal", inManagedObjectContext: self.managedObjectContext) as! NTCDMeal
        item.dateTime = dateTime
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
