//
//  NTMealDetailsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTMealDetailsViewControllerDelegate: class {
    func mealDetailsViewController(sender: NTMealDetailsViewController, didSaveMeal meal: NTMeal)
}

class NTMealDetailsViewController: UIViewController, NTFoodSearchViewControllerDelegate, NTMealDetailsViewDataSource, NTMealDetailsViewDelegate {
    
    weak internal var delegate: NTMealDetailsViewControllerDelegate?
    
    private var meal: NTMeal
    private var initialPresentation: Bool = true
    
    init() {
        self.meal = NTMeal(dateTime: NSDate())
        super.init(nibName: nil, bundle: nil)
    }
    
    init(meal: NTMeal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    lazy private var mealDetailsView: NTMealDetailsView = {
        let view = NTMealDetailsView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("New Meal", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add Item", comment: ""), style: .Plain, target: self, action: #selector(addItemButtonDidTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .Plain, target: self, action: #selector(saveButtonDidTap(_:)))
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.backgroundColor()
        self.view.addSubview(self.mealDetailsView)
        
        self.updateViewConstraints()
    
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.meal.mealItems.count == 0 {
            if self.initialPresentation {
                self.initialPresentation = false
                self.presentNTFoodSearchViewController()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.mealDetailsView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func addItemButtonDidTap(sender: UIBarButtonItem) {
        self.presentNTFoodSearchViewController()
    }
    
    internal func saveButtonDidTap(sender: UIBarButtonItem) {
        if self.meal.mealItems.count > 0 {
            self.delegate?.mealDetailsViewController(self, didSaveMeal: self.meal)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func presentNTFoodSearchViewController() {
        let controller = NTFoodSearchViewController()
        controller.delegate = self
        self.navigationController?.presentViewController(controller)
    }
    
    // MARK: NTFoodSearchViewControllerDelegate methods
    
    internal func foodSearchViewController(sender: NTFoodSearchViewController, didSelectFood food: NTFood, quantity: Int, measureIndex: Int) {
        self.meal.mealItems.append(NTMealItem(food: food, quantity: quantity, measureIndex: measureIndex))
        sender.dismissViewControllerAnimated(true, completion: nil)
        self.mealDetailsView.reloadData()
        self.mealDetailsView.selectFoodAtIndex(self.meal.mealItems.count - 1)
    }
    
    // MARK: NTMealDetailsViewDataSource methods
    
    internal func mealDetailsViewNumberOfFoods(sender: NTMealDetailsView) -> Int {
        return self.meal.mealItems.count
    }
    
    internal func mealDetailsView(sender: NTMealDetailsView, titleForFoodAtIndex index: Int) -> String {
        return self.meal.mealItems[index].food.name
    }
    
    internal func mealDetailsViewDateForMeal(sender: NTMealDetailsView) -> NSDate {
        return self.meal.dateTime
    }
    
    // MARK: NTMealDetailsViewDelegate methods
    
    internal func mealDetailsView(sender: NTMealDetailsView, didChangeDateForMeal date: NSDate) {
        self.meal.dateTime = date
    }

}
