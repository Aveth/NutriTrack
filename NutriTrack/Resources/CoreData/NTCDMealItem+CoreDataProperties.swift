//
//  NTCDMealItem+CoreDataProperties.swift
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

extension NTCDMealItem {

    @NSManaged var foodID: String?
    @NSManaged var measureIndex: NSNumber?
    @NSManaged var quantity: NSNumber?

}
