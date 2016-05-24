//
//  UserProtocol.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-23.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol UserProfileProtocol {
    
    var id: String? { get }
    var recentFoods: [Food]? { get }
    var selectedNutrients: [Nutrient]? { get }
    
    func refresh(success success: (() -> Void), failure: ((error: ErrorType) -> Void)?)
    
}
