//
//  NTMealDayViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTMealDayViewController: UIViewController, NTMealDayViewDataSource {
    
    internal var date: NSDate
    internal var meals: [NTMeal]
    
    static private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM, dd"
        return formatter
    }()
    
    lazy private var mealDayView: NTMealDayView = {
        let view = NTMealDayView()
        view.dataSource = self
        return view
    }()
    
    internal init(date: NSDate, meals: [NTMeal]) {
        self.date = date
        self.meals = meals
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.mealDayView)
        self.mealDayView.reloadData()
        
        self.updateViewConstraints()
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.mealDayView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: NTMealDayViewDataSource methods
    
    internal func mealDayViewTitleForDay(sender: NTMealDayView) -> String {
        return NTMealDayViewController.dateFormatter.stringFromDate(self.date)
    }
    
    internal func mealDayViewNumberOfNutrients(sender: NTMealDayView) -> Int {
        guard let count = self.meals.first?.mealItems.first?.food.nutrients.count else {
            return 0
        }
        return count
    }
    
    internal func mealDayView(sender: NTMealDayView, titleForNutrientAtIndex index: Int) -> String {
        guard let name = self.meals.first?.mealItems.first?.food.sortedNutrients[index].name else {
            return ""
        }
        
        return name
    }
    
    internal func mealDayView(sender: NTMealDayView, valueForNutrientAtIndex index: Int) -> Float {
        return self.meals.reduce(0.0) { (total: Float, meal: NTMeal) in
            return meal.mealItems.reduce(total) { (itemTotal: Float, item: NTMealItem) in
                let measureValue = item.food.measures[item.measureIndex].value
                let quantityValue = item.quantity
                let nutrientValue = item.food.sortedNutrients[index].value
                let adjustedValue = (nutrientValue / NTNutrient.BaseMeasuresGrams) * measureValue * Float(quantityValue)
                return adjustedValue
            }
        }
    }
    
    internal func mealDayView(sender: NTMealDayView, unitForNutrientAtIndex index: Int) -> String {
        guard let unit = self.meals.first?.mealItems.first?.food.sortedNutrients[index].unit else {
            return ""
        }
        return unit
    }


}
