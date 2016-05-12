//
//  CDMeasure+CoreDataProperties.swift
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

extension CDMeasure {

    @NSManaged var name: String?
    @NSManaged var value: NSNumber?
    @NSManaged var index: NSNumber?

}
