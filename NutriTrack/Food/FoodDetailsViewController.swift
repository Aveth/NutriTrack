//
//  FoodDetailsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-20.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol FoodDetailsViewControllerDelegate: class {
    func foodDetailsViewController(sender: FoodDetailsViewController, didConfirmFood food:Food, quantity: Int, measureIndex: Int)
}

class FoodDetailsViewController: BaseViewController, FoodDetailsViewDelegate, FoodDetailsViewDataSource {
    
    private var _completeText: String = NSLocalizedString("Done", comment: "")
    internal var completeText: String? {
        get {
            return self._completeText
        }
        set {
            if let text = newValue {
                self._completeText = text
                self.navigationItem.rightBarButtonItem?.title = text
            }
        }
    }
    
    weak internal var delegate: FoodDetailsViewControllerDelegate?
    internal var food: Food
    internal var measureIndex: Int
    internal var quantity: Int
    
    private let quantities: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    private let searchProvider: SearchProvider = SearchProvider(service: SearchService())
    
    private lazy var foodDetailsView: FoodDetailsView = {
        let view: FoodDetailsView = FoodDetailsView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var spinner: LoadingIndicator = {
        let spinner = LoadingIndicator()
        return spinner
    }()
    
    internal init(food: Food, quantity: Int, measureIndex: Int) {
        self.food = food
        self.quantity = 1
        self.measureIndex = 0
        super.init(nibName: nil, bundle: nil)
    }
    
    internal convenience init(food: Food) {
        self.init(food: food, quantity: 1, measureIndex: 0)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle = NSLocalizedString("Food Details", comment: "")
        self.rightBarButtonTitle = self._completeText
        
        self.view.addSubview(self.foodDetailsView)
        self.view.addSubview(self.spinner)

        self.reloadData()
        self.updateViewConstraints()
        
    }
    
    override internal func rightBarButtonDidTap(sender: UIBarButtonItem) {
         self.delegate?.foodDetailsViewController(self, didConfirmFood: self.food, quantity: self.quantity, measureIndex: self.measureIndex)
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.spinner.autoPinEdgesToSuperviewEdges()
        self.foodDetailsView.autoPinEdgesToSuperviewEdges()
    }
    
    private func reloadData() {
        if let foodId: String = food.id {
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.spinner.activate()
            self.searchProvider.fetchFoodDetails(foodId, diet: Nutrient.Diet.Renal,
                success: { (result: Food) -> Void in
                    self.food = result
                    self.foodDetailsView.reloadData()
                    self.navigationItem.rightBarButtonItem?.enabled = true
                    self.spinner.deactivte()
                },
                failure: { (error: ErrorType) -> Void in
                    self.navigationItem.rightBarButtonItem?.enabled = true
                    self.spinner.deactivte()
                }
            )
        }
    }
    
    // MARK: FoodDetailsViewDataSource methods
    
    internal func foodDetailsViewTitleForFood(sender: FoodDetailsView) -> String {
        return self.food.name + " (" + self.food.id + ")"
    }
    
    internal func foodDetailsViewNumberOfMeasures(sender: FoodDetailsView) -> Int {
        return self.food.measures.count
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, titleForMeasureAtIndex index: Int) -> String {
        return self.food.measures[index].name
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, valueForMeasureAtIndex index: Int) -> Float {
        return self.food.measures[index].value
    }
    
    internal func foodDetailsViewNumberOfNutrients(sender: FoodDetailsView) -> Int {
        return self.food.nutrients.count
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, titleForNutrientAtIndex index: Int) -> String {
        return self.food.nutrients[index].name
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, unitForNutrientAtIndex index: Int) -> String {
        return self.food.nutrients[index].unit
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, valueForNutrientAtIndex index: Int) -> Float {
        let nutrientValue = self.food.nutrients[index].value
        let measureValue = self.food.measures[self.measureIndex].value
        let quantityValue = self.quantity
        let adjustedNutrientValue = (nutrientValue / Nutrient.BaseMeasuresGrams) * measureValue * Float(quantityValue)
        return adjustedNutrientValue
    }
    
    internal func foodDetailsViewNumberOfQuantities(sender: FoodDetailsView) -> Int {
        return self.quantities.count
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, valueForQuantityAtIndex index: Int) -> Int {
        return self.quantities[index]
    }
    
    internal func foodDetailsViewIndexForSelectedMeasure(sender: FoodDetailsView) -> Int {
        return self.measureIndex
    }
    
    internal func foodDetailsViewIndexForSelectedQuantity(sender: FoodDetailsView) -> Int {
        if let num = self.quantities.indexOf(self.quantity) {
            return num
        }
        return 0
    }
    
    // MARK: FoodDetailsViewDelegate methods
    
    internal func foodDetailsView(sender: FoodDetailsView, didSelectMeasureAtIndex index: Int) {
        self.measureIndex = index
    }
    
    internal func foodDetailsView(sender: FoodDetailsView, didSelectQuantityAtIndex index: Int) {
        self.quantity = self.quantities[index]
    }
    
    
}
