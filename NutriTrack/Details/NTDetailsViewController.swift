//
//  NTDetailsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-20.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTDetailsViewController: UIViewController, NTDetailsViewDelegate, NTDetailsViewDataSource {
    
    internal var foodItem: NTFoodItem

    private let searchProvider: NTSearchProvider = NTSearchProvider(service: NTSearchService())
    private lazy var detailsView: NTDetailsView = {
        let view: NTDetailsView = NTDetailsView()
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
        self.view.addSubview(self.detailsView)

        self.reloadData()
        self.updateViewConstraints()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.detailsView.autoPinEdgesToSuperviewEdges()
    }
    
    private func reloadData() {
        if let foodId: String = foodItem.id {
            self.searchProvider.fetchFoodDetails(foodId, diet: NTSearchProvider.Diet.Renal,
                success: { (result: NTFoodItem) -> Void in
                    self.foodItem = result
                    self.detailsView.reloadData()
                },
                failure: { (error: ErrorType) -> Void in
                    
                }
            )
        }
    }
    
    // MARK: NTDetailsViewDataSource methods
    
    internal func detailsViewNameForFood(sender: NTDetailsView) -> String {
        return self.foodItem.name
    }
    
    internal func detailsViewNumberOfMeasures(sender: NTDetailsView) -> Int {
        return self.foodItem.measures.count
    }
    
    internal func detailsView(sender: NTDetailsView, nameForMeasureAtIndex index: Int) -> String {
        return self.foodItem.measures[index].name
    }
    
    internal func detailsView(sender: NTDetailsView, valueForMeasureAtIndex index: Int) -> Float {
        return self.foodItem.measures[index].value
    }
    
    internal func detailsViewNumberOfNutrients(sender: NTDetailsView) -> Int {
        return self.foodItem.nutrients.count
    }
    
    internal func detailsView(sender: NTDetailsView, nameForNutrientAtIndex index: Int) -> String {
        return self.foodItem.nutrients[index].name
    }
    
    internal func detailsView(sender: NTDetailsView, unitForNutrientAtIndex index: Int) -> String {
        return self.foodItem.nutrients[index].unit
    }
    
    internal func detailsView(sender: NTDetailsView, valueForNutrientAtIndex index: Int) -> Float {
        return self.foodItem.nutrients[index].value
    }
    
    
}
