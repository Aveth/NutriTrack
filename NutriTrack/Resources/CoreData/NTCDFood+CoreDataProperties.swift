//
//  NTCDFood+CoreDataProperties.swift
//  
//
//  Created by Avais on 2016-04-27.
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
    @NSManaged var selectedMeasure: NTCDMeasure?
    
    @NSManaged func addMeasuresObject(measure: NTCDMeasure)
    @NSManaged func addNutrientsObject(nutrient: NTCDNutrient)

}
