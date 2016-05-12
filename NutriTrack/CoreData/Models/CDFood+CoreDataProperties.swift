//
//  CDFood+CoreDataProperties.swift
//  
//
//  Created by Avais on 2016-05-12.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDFood {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var measures: NSSet?
    @NSManaged var nutrients: NSSet?
    
    @NSManaged func addMeasuresObject(object: NSManagedObject)
    @NSManaged func addNutrientsObject(object: NSManagedObject)

}
