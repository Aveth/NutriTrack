//
//  NTFoodDetailsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-20.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTFoodDetailsViewController: UIViewController, NTFoodDetailsViewDelegate, NTFoodDetailsViewDataSource {
    
    internal var foodItem: NTFoodItem

    private let searchProvider: NTSearchProvider = NTSearchProvider(service: NTSearchService())
    private lazy var foodDetailsView: NTFoodDetailsView = {
        let view: NTFoodDetailsView = NTFoodDetailsView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    internal init(foodItem:NTFoodItem) {
        self.foodItem = foodItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.foodDetailsView)

        self.reloadData()
        self.updateViewConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.foodDetailsView.autoPinEdgesToSuperviewEdges()
    }
    
    private func reloadData() {
        if let foodId: String = foodItem.id {
            self.searchProvider.fetchFoodDetails(foodId, diet: NTSearchProvider.Diet.Renal,
                success: { (result: NTFoodItem) -> Void in
                    self.foodItem = result
                    self.foodDetailsView.reloadData()
                },
                failure: { (error: ErrorType) -> Void in
                    
                }
            )
        }
    }
    
    // MARK: NTFoodDetailsViewDataSource methods
    
    internal func foodDetailsViewNameForFood(sender: NTFoodDetailsView) -> String {
        return self.foodItem.name
    }
    
    internal func foodDetailsViewNumberOfMeasures(sender: NTFoodDetailsView) -> Int {
        return self.foodItem.measures.count
    }
    
    internal func foodDetailsView(sender: NTFoodDetailsView, nameForMeasureAtIndex index: Int) -> String {
        return self.foodItem.measures[index].name
    }
    
    internal func foodDetailsView(sender: NTFoodDetailsView, valueForMeasureAtIndex index: Int) -> Float {
        return self.foodItem.measures[index].value
    }
    
    internal func foodDetailsViewNumberOfNutrients(sender: NTFoodDetailsView) -> Int {
        return self.foodItem.nutrients.count
    }
    
    internal func foodDetailsView(sender: NTFoodDetailsView, nameForNutrientAtIndex index: Int) -> String {
        return self.foodItem.nutrients[index].name
    }
    
    internal func foodDetailsView(sender: NTFoodDetailsView, unitForNutrientAtIndex index: Int) -> String {
        return self.foodItem.nutrients[index].unit
    }
    
    internal func foodDetailsView(sender: NTFoodDetailsView, valueForNutrientAtIndex index: Int) -> Float {
        return self.foodItem.nutrients[index].value
    }
    
    
}
