//
//  DayViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, DayViewDataSource {
    
    internal var date: NSDate
    internal var meals: [Meal]
    
    static private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM, dd"
        return formatter
    }()
    
    lazy private var dayView: DayView = {
        let view = DayView()
        view.dataSource = self
        return view
    }()
    
    internal init(date: NSDate, meals: [Meal]) {
        self.date = date
        self.meals = meals
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.dayView)
        self.dayView.reloadData()
        
        self.updateViewConstraints()
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.dayView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: DayViewDataSource methods
    
    internal func dayViewTitleForDay(sender: DayView) -> String {
        return DayViewController.dateFormatter.stringFromDate(self.date)
    }
    
    internal func dayViewNumberOfNutrients(sender: DayView) -> Int {
        guard let count = self.meals.first?.mealItems.first?.food.nutrients.count else {
            return 0
        }
        return count
    }
    
    internal func dayView(sender: DayView, titleForNutrientAtIndex index: Int) -> String {
        guard let name = self.meals.first?.mealItems.first?.food.sortedNutrients[index].name else {
            return ""
        }
        
        return name
    }
    
    internal func dayView(sender: DayView, valueForNutrientAtIndex index: Int) -> Float {
        return self.meals.reduce(0.0) { (total: Float, meal: Meal) in
            return meal.mealItems.reduce(total) { (itemTotal: Float, item: MealItem) in
                let measureValue = item.food.measures[item.measureIndex].value
                let quantityValue = item.quantity
                let nutrientValue = item.food.sortedNutrients[index].value
                let adjustedValue = (nutrientValue / Nutrient.BaseMeasuresGrams) * measureValue * Float(quantityValue)
                return adjustedValue
            }
        }
    }
    
    internal func dayView(sender: DayView, unitForNutrientAtIndex index: Int) -> String {
        guard let unit = self.meals.first?.mealItems.first?.food.sortedNutrients[index].unit else {
            return ""
        }
        return unit
    }


}
