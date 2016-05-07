//
//  ViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTMealsViewController: NTViewController, NTMealDetailsViewControllerDelegate, UIPageViewControllerDataSource {
    
    internal var dataManager: NTMealsManger = NTMealsManger(provider: NTMealsCoreDataProvider())
    lazy private var emptyView: NTEmptyView = NTEmptyView()
    
    lazy private var mealsPageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        controller.dataSource = self
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle = NSLocalizedString("My Food Diary", comment: "")
        self.rightBarButtonImage = UIImage(named: "plus")
        
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.mealsPageViewController.view)
      
        self.updateViewConstraints()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let hasMeals = self.dataManager.meals.count > 0
        self.emptyView.hidden = hasMeals
        self.mealsPageViewController.view.hidden = !hasMeals
    }
    
    override internal func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.mealsPageViewController.setViewControllers([NTMealDayViewController(date: NSDate().dateOnly()!, meals: self.dataManager.mealsForToday())], direction: .Forward, animated: false, completion: nil)
    }
    
    override internal func rightBarButtonDidTap(sender: UIBarButtonItem) {
        self.presentMealDetailsWithMeal(nil)
    }
    
    internal func presentMealDetailsWithFood(food: NTFood, quantity: Int, measureIndex: Int) {
        let meal = NTMeal(dateTime: NSDate())
        meal.mealItems.append(NTMealItem(food: food, quantity: quantity, measureIndex: measureIndex))
        self.presentMealDetailsWithMeal(meal)
    }
    
    private func presentMealDetailsWithMeal(meal: NTMeal?) {
        let controller: NTMealDetailsViewController
        if let m = meal {
            controller = NTMealDetailsViewController(meal: m)
        } else {
            controller = NTMealDetailsViewController()
        }
        controller.delegate = self
        controller.isModal = true
        self.navigationController?.presentViewController(controller, animated: true)
            
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.emptyView.autoPinEdgesToSuperviewEdges()
        self.mealsPageViewController.view.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: NTMealDetailsViewControllerDelegate methods
    
    internal func mealDetailsViewController(sender: NTMealDetailsViewController, didSaveMeal meal: NTMeal) {
        self.dataManager.saveMeal(meal)
    }
    
    // MARK: UIPageViewControllerDataSource methods
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let date = (viewController as! NTMealDayViewController).date
        
        if date.isEqualToDate(NSDate().dateOnly()!) {
            return nil
        }
        
        guard let
            meals = self.dataManager.mealsForFirstDateAfterDate(date),
            dayDate = meals.first?.dateTime.dateOnly()
        else {
            return nil
        }
        
        return NTMealDayViewController(date: dayDate, meals: meals)
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let date = (viewController as! NTMealDayViewController).date
        guard let
            meals = self.dataManager.mealsForFirstDateBeforeDate(date),
            dayDate = meals.first?.dateTime.dateOnly()
        else {
           return nil
        }
        return NTMealDayViewController(date: dayDate, meals: meals)
    }

}
