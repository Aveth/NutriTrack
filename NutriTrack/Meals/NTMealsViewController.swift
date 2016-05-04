//
//  ViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTMealsViewController: NTViewController, NTMealDetailsViewControllerDelegate {
    
    internal var dataManager: NTMealsManger = NTMealsManger(provider: NTMealsCoreDataProvider())
    lazy private var emptyView: NTEmptyView = NTEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle = NSLocalizedString("Log Book", comment: "")
        self.rightBarButtonImage = UIImage(named: "plus")
        
        self.view.addSubview(self.emptyView)
      
        self.updateViewConstraints()
    }
    
    override internal func rightBarButtonDidTap(sender: UIBarButtonItem) {
        let controller = NTMealDetailsViewController()
        controller.delegate = self
        //controller.isModal = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    internal func presentMealDetailsWithFood(food: NTFood, quantity: Int, measureIndex: Int) {
        let meal = NTMeal(dateTime: NSDate())
        meal.mealItems.append(NTMealItem(food: food, quantity: quantity, measureIndex: measureIndex))
        let controller = NTMealDetailsViewController(meal: meal)
        controller.delegate = self
        controller.isModal = true
        self.navigationController?.presentViewController(controller, animated: true)
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.emptyView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: NTMealDetailsViewControllerDelegate methods
    
    internal func mealDetailsViewController(sender: NTMealDetailsViewController, didSaveMeal meal: NTMeal) {
        self.dataManager.saveMeal(meal)
    }

}
