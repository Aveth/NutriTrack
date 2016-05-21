//
//  CDModelAdapter.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-20.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation
import CoreData

class CDModelAdapter {
    
    static internal var sharedAdapter: CDModelAdapter = CDModelAdapter()
    
    internal func mealItemFromCoreData(coreDataMealItem: CDMealItem?, coreDataFood: CDFood) -> MealItem? {
        guard let
            measureIndex = coreDataMealItem?.measureIndex,
            quantity = coreDataMealItem?.quantity,
            resultFood = self.foodFromCoreData(coreDataFood)
        else {
            return nil
        }
        let resultMealItem = MealItem(food: resultFood, quantity: quantity.integerValue, measureIndex: measureIndex.integerValue)
        return resultMealItem
    }
    
    internal func foodFromCoreData(coreDataFood: CDFood?) -> Food? {
        guard let
            id = coreDataFood?.id,
            name = coreDataFood?.name,
            category = coreDataFood?.category,
            nutrients = coreDataFood?.nutrients?.allObjects as? [CDNutrient],
            measures = coreDataFood?.measures?.allObjects as? [CDMeasure]
        else {
            return nil
        }
        
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
    
    internal func nutrientFromCoreData(coreDataNutrient: CDNutrient?) -> Nutrient? {
        guard let
            id = coreDataNutrient?.id,
            name = coreDataNutrient?.name,
            unit = coreDataNutrient?.unit,
            value = coreDataNutrient?.value
        else {
           return nil
        }
        return Nutrient(id: id, name: name, unit: unit, value: value.floatValue)
    }
    
    internal func measureFromCoreData(coreDataMeasure: CDMeasure?) -> Measure? {
        guard let
            index = coreDataMeasure?.index?.integerValue,
            name = coreDataMeasure?.name,
            value = coreDataMeasure?.value
        else {
          return nil
        }
        return Measure(index: index, name: name, value: value.floatValue)
    }

}
