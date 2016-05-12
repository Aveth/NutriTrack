//
//  DiaryViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, MealDetailsViewControllerDelegate, UIPageViewControllerDataSource {
    
    internal var dataManager: MealsManger = MealsManger(provider: MealsCoreDataProvider())
    lazy private var emptyView: EmptyView = EmptyView()
    
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
        
        guard self.dataManager.meals.count > 0 else {
            return
        }
        
        if let meals = self.dataManager.mealsForToday() {
             self.mealsPageViewController.setViewControllers([DiaryPageViewController(date: NSDate().dateOnly()!, meals: meals)], direction: .Forward, animated: false, completion: nil)
        } else if let meals = self.dataManager.mealsForFirstDateBeforeDate(NSDate().dateOnly()!) {
            self.mealsPageViewController.setViewControllers([DiaryPageViewController(date: (meals.first?.dateTime.dateOnly()!)!, meals: meals)], direction: .Forward, animated: false, completion: nil)
        }
       
    }
    
    override internal func rightBarButtonDidTap(sender: UIBarButtonItem) {
        self.presentMealDetailsWithMeal(nil)
    }
    
    internal func presentMealDetailsWithFood(food: Food, quantity: Int, measureIndex: Int) {
        let meal = Meal(dateTime: NSDate())
        meal.mealItems.append(MealItem(food: food, quantity: quantity, measureIndex: measureIndex))
        self.presentMealDetailsWithMeal(meal)
    }
    
    private func presentMealDetailsWithMeal(meal: Meal?) {
        let controller: MealDetailsViewController
        if let m = meal {
            controller = MealDetailsViewController(meal: m)
        } else {
            controller = MealDetailsViewController()
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
    
    // MARK: MealDetailsViewControllerDelegate methods
    
    internal func mealDetailsViewController(sender: MealDetailsViewController, didSaveMeal meal: Meal) {
        self.dataManager.saveMeal(meal)
    }
    
    // MARK: UIPageViewControllerDataSource methods
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let date = (viewController as! DiaryPageViewController).date
        
        if date.isEqualToDate(NSDate().dateOnly()!) {
            return nil
        }
        
        guard let
            meals = self.dataManager.mealsForFirstDateAfterDate(date),
            dayDate = meals.first?.dateTime.dateOnly()
        else {
            return nil
        }
        
        return DiaryPageViewController(date: dayDate, meals: meals)
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let date = (viewController as! DiaryPageViewController).date
        guard let
            meals = self.dataManager.mealsForFirstDateBeforeDate(date),
            dayDate = meals.first?.dateTime.dateOnly()
        else {
           return nil
        }
        return DiaryPageViewController(date: dayDate, meals: meals)
    }

}
