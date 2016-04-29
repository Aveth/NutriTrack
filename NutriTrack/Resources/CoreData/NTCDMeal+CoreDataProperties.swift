//
//  NTCDMeal+CoreDataProperties.swift
//  
//
//  Created by Avais on 2016-04-29.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NTCDMeal {

    @NSManaged var dateTime: NSDate?
    @NSManaged var id: String?
    @NSManaged var mealItems: NSSet?
    
    @NSManaged func addMealItemsObject(object: NSManagedObject)

}
