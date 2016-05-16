//
//  MealDetailsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol MealDetailsViewControllerDelegate: class {
    func mealDetailsViewController(sender: MealDetailsViewController, didSaveMeal meal: Meal)
}

class MealDetailsViewController: BaseViewController, FoodSearchViewControllerDelegate, MealDetailsViewDataSource, MealDetailsViewDelegate {
    
    weak internal var delegate: MealDetailsViewControllerDelegate?
    
    private var meal: Meal
    
    lazy private var mealDetailsView: MealDetailsView = {
        let view = MealDetailsView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy private var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "check"), style: .Plain, target: self, action: #selector(rightBarButtonDidTap(_:)))
        button.enabled = false
        return button
    }()
    
    init() {
        self.meal = Meal(dateTime: NSDate())
        super.init(nibName: nil, bundle: nil)
    }
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        let isNew: Bool = self.meal.mealItems.count > 0
        self.navigationTitle = NSLocalizedString(isNew ? "New Meal" : "Meal", comment: "")
        self.navigationItem.rightBarButtonItems = [
            self.saveButton,
            UIBarButtonItem(image: UIImage(named: "plus"), style: .Plain, target: self, action: #selector(addItemButtonDidTap(_:))),
        ]
        
        self.view.addSubview(self.mealDetailsView)
        
        self.updateViewConstraints()
    
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.saveButton.enabled = self.meal.mealItems.count > 0
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.mealDetailsView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func addItemButtonDidTap(sender: UIBarButtonItem) {
        self.presentFoodResultsViewController()
    }
    
    override internal func rightBarButtonDidTap(sender: UIBarButtonItem) {
        self.delegate?.mealDetailsViewController(self, didSaveMeal: self.meal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override internal func leftBarButtonDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func presentFoodResultsViewController() {
        let controller = FoodSearchViewController()
        controller.delegate = self
        controller.isModal = true
        self.navigationController?.presentViewController(controller)
    }
    
    // MARK: FoodSearchViewControllerDelegate methods
    
    internal func foodSearchViewController(sender: FoodSearchViewController, didSelectFood food: Food, quantity: Int, measureIndex: Int) {
        self.meal.mealItems.append(MealItem(food: food, quantity: quantity, measureIndex: measureIndex))
        sender.dismissViewControllerAnimated(true, completion: nil)
        self.mealDetailsView.reloadData()
        self.mealDetailsView.selectFoodAtIndex(self.meal.mealItems.count - 1)
    }
    
    // MARK: MealDetailsViewDataSource methods
    
    internal func mealDetailsViewNumberOfFoods(sender: MealDetailsView) -> Int {
        return self.meal.mealItems.count
    }
    
    internal func mealDetailsView(sender: MealDetailsView, titleForFoodAtIndex index: Int) -> String {
        return self.meal.mealItems[index].food.name
    }
    
    internal func mealDetailsViewDateForMeal(sender: MealDetailsView) -> NSDate {
        return self.meal.dateTime
    }
    
    // MARK: MealDetailsViewDelegate methods
    
    internal func mealDetailsView(sender: MealDetailsView, didChangeDateForMeal date: NSDate) {
        self.meal.dateTime = date
    }

}
