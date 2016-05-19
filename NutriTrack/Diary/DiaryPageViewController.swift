//
//  DiaryPageViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class DiaryPageViewController: UIViewController, DiaryPageViewDataSource {
    
    internal var page: DiaryPage
    
    static private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM, dd"
        return formatter
    }()
    
    lazy private var diaryPageView: DiaryPageView = {
        let view = DiaryPageView()
        view.dataSource = self
        return view
    }()
    
    internal init(page: DiaryPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.diaryPageView)
        self.diaryPageView.reloadData()
        
        self.updateViewConstraints()
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.diaryPageView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: DiaryPageViewDataSource methods
    
    internal func diaryPageViewTitleForDay(sender: DiaryPageView) -> String {
        return DiaryPageViewController.dateFormatter.stringFromDate(self.page.date)
    }
    
    internal func diaryPageViewNumberOfNutrients(sender: DiaryPageView) -> Int {
        guard let count = self.page.meals.first?.mealItems.first?.food.nutrients.count else {
            return 0
        }
        return count
    }
    
    internal func diaryPageView(sender: DiaryPageView, titleForNutrientAtIndex index: Int) -> String {
        guard let name = self.page.meals.first?.mealItems.first?.food.sortedNutrients[index].name else {
            return ""
        }
        
        return name
    }
    
    internal func diaryPageView(sender: DiaryPageView, valueForNutrientAtIndex index: Int) -> Float {
        return self.page.meals.reduce(0.0) { (total: Float, meal: Meal) in
            return meal.mealItems.reduce(total) { (itemTotal: Float, item: MealItem) in
                let measureValue = item.food.sortedMeasures[item.measureIndex].value
                let quantityValue = item.quantity
                let nutrientValue = item.food.sortedNutrients[index].value
                let adjustedValue = (nutrientValue / Nutrient.BaseMeasuresGrams) * measureValue * Float(quantityValue)
                return adjustedValue
            }
        }
    }
    
    internal func diaryPageView(sender: DiaryPageView, unitForNutrientAtIndex index: Int) -> String {
        guard let unit = self.page.meals.first?.mealItems.first?.food.sortedNutrients[index].unit else {
            return ""
        }
        return unit
    }


}
