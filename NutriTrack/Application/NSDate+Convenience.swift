//
//  File.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

extension NSDate {
    
    internal func dateOnly() -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: self)
        return calendar.dateFromComponents(components)
    }
    
}