//
//  NTCDFood+CoreDataProperties.swift
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

extension NTCDFood {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var measures: NSSet?
    @NSManaged var nutrients: NSSet?
    
    @NSManaged func addNutrientsObject(object: NSManagedObject)
    @NSManaged func addMeasuresObject(object: NSManagedObject)

}
