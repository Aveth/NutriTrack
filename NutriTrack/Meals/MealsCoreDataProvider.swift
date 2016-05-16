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
    
    internal func fetchMeals() -> [Meal] {
        return self.fetchMealsWithPredicate(nil)
    }
    
    lazy private var managedObjectContext: NSManagedObjectContext = {
        return CDContextProvider.sharedProvider.managedObjectContext
    }()
    
    func fetchMealsForStartDate(startDate: NSDate, endDate: NSDate) -> [Meal] {
        let predicate = NSPredicate(format: "dateTime >= %@ AND dateTime < %@", startDate, endDate)
        return self.fetchMealsWithPredicate(predicate)
    }
    
    private func fetchMealsWithPredicate(predicate: NSPredicate?) -> [Meal] {
        var resultMeals = [Meal]()
        do {
            let request = NSFetchRequest(entityName: "CDMeal")
            request.predicate = predicate
            request.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: true)]
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
    
    internal func insertMeal(meal: Meal) {
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
    
    internal func fetchFoodByID(id: String) -> CDFood? {
        let predicate = NSPredicate(format: "id = %@", id)
        let request = NSFetchRequest(entityName: "CDFood")
        request.predicate = predicate
        do {
            let foods =  try self.managedObjectContext.executeFetchRequest(request) as!     [CDFood]
            return foods.first
        } catch {
            return nil
        }
    }
    
    internal func updateMeal(meal: Meal) {
        //code
    }
    
    internal func deleteMeal(meal: Meal) {
        //self.managedObjectContext.deleteObject(meal)
    }
    
    private func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch let error {
            print("\(error)")
        }
    }
    
    private func mealItemFromCoreData(coreDataMealItem: CDMealItem?) -> MealItem? {
        if let
            measureIndex = coreDataMealItem?.measureIndex,
            quantity = coreDataMealItem?.quantity,
            foodID = coreDataMealItem?.foodID
        {
            if let
                coreDataFood = self.fetchFoodByID(foodID),
                resultFood = self.foodFromCoreData(coreDataFood)
            {
                let resultMealItem = MealItem(food: resultFood, quantity: quantity.integerValue, measureIndex: measureIndex.integerValue)
                return resultMealItem
            }
        }
        return nil
    }
    
    private func foodFromCoreData(coreDataFood: CDFood?) -> Food? {
        if let
            id = coreDataFood?.id,
            name = coreDataFood?.name,
            category = coreDataFood?.category,
            nutrients = coreDataFood?.nutrients?.allObjects as? [CDNutrient],
            measures = coreDataFood?.measures?.allObjects as? [CDMeasure]
        {
            let resultFood = Food(id: id, name: name, category: category)
            for nutrient: CDNutrient in nutrients {
                if let result = self.nutrientFromCoreData(nutrient) {
                    resultFood.nutrients.append(result)
                }
            }
            for measure: CDMeasure in measures {
                if let result = self.measureFromCoreData(measure) {
                    resultFood.measures.append(result)
                }
            }
            return resultFood
        }
        return nil
    }
    
    private func nutrientFromCoreData(coreDataNutrient: CDNutrient?) -> Nutrient? {
        if let
            id = coreDataNutrient?.id,
            name = coreDataNutrient?.name,
            unit = coreDataNutrient?.unit,
            value = coreDataNutrient?.value
        {
            return Nutrient(id: id, name: name, unit: unit, value: value.floatValue)
        }
        return nil
    }
    
    private func measureFromCoreData(coreDataMeasure: CDMeasure?) -> Measure? {
        if let
            index = coreDataMeasure?.index?.integerValue,
            name = coreDataMeasure?.name,
            value = coreDataMeasure?.value
        {
            return Measure(index: index, name: name, value: value.floatValue)
        }
        return nil
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
