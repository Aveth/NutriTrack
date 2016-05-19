//
//  DiaryViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, MealDetailsViewControllerDelegate, UIPageViewControllerDataSource {
    
    internal var dataManager: DiaryManger = DiaryManger(provider: MealsCoreDataProvider())
    
    lazy private var emptyView: EmptyView = EmptyView()
    
    lazy private var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        controller.dataSource = self
        return controller
    }()
    
    lazy private var spinner: LoadingIndicator = {
        let spinner = LoadingIndicator()
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle = NSLocalizedString("My Food Diary", comment: "")
        self.rightBarButtonImage = UIImage(named: "plus")
        
        self.view.addSubview(self.pageViewController.view)
        self.view.addSubview(self.emptyView)
        self.view.addSubview(self.spinner)
      
        self.updateViewConstraints()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.spinner.activate()
        self.dataManager.refresh(
            success: { (results) in
                self.spinner.deactivte()
    
                guard let page = results?.last else {
                    self.emptyView.hidden = false
                    self.pageViewController.view.hidden = true
                    return
                }
                
                self.emptyView.hidden = true
                self.pageViewController.view.hidden = false
                self.pageViewController.setViewControllers([DiaryPageViewController(page: page)], direction: .Forward, animated: false, completion: nil)
            },
            failure: { (error) in
                self.spinner.deactivte()
                self.emptyView.hidden = false
                self.pageViewController.view.hidden = true
            }
        )
        
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
        self.pageViewController.view.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: MealDetailsViewControllerDelegate methods
    
    internal func mealDetailsViewController(sender: MealDetailsViewController, didSaveMeal meal: Meal) {
        self.dataManager.saveMeal(meal)
    }
    
    // MARK: UIPageViewControllerDataSource methods
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let
            page = (viewController as? DiaryPageViewController)?.page,
            nextPage = self.dataManager.nextPageAfterPage(page)
        else {
            return nil
        }
        
        return DiaryPageViewController(page: nextPage)
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let
            page = (viewController as? DiaryPageViewController)?.page,
            prevPage = self.dataManager.nextPageAfterPage(page)
        else {
            return nil
        }
        
        return DiaryPageViewController(page: prevPage)
    }

}
