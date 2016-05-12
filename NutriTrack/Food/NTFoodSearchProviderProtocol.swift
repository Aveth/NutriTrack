//
//  NTFoodSearchProviderProtocol.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import Foundation

protocol NTFoodSearchProviderProtocol: class {

    func findResultsForSearchQuery(query: String)
    func fetchDetailsWithID(id: String)

}
