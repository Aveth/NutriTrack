//
//  NTTabBarControllerViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-30.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTTabBarController: UITabBarController, UITabBarControllerDelegate, NTFoodSearchViewControllerDelegate {
    
    lazy private var recipesViewController: NTRecipesViewController = {
        let controller = NTRecipesViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Recipes", comment: ""), image: UIImage(named: "cutting_board")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var searchViewController: NTFoodSearchViewController = {
        let controller = NTFoodSearchViewController()
        controller.completeText = NSLocalizedString("Create Meal", comment: "")
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "search")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var mealsViewController: NTMealsViewController = {
        let controller = NTMealsViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Log Book", comment: ""), image: UIImage(named: "log_book")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var profileViewController: NTProfileViewController = {
        let controller = NTProfileViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "profile"), selectedImage: nil)
        return controller
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [
            self.navigationControllerWithViewController(self.recipesViewController),
            self.navigationControllerWithViewController(self.searchViewController),
            self.navigationControllerWithViewController(self.mealsViewController),
            self.navigationControllerWithViewController(self.profileViewController)
        ]
        
        self.searchViewController.delegate = self
    
    }
    
    private func navigationControllerWithViewController(controller: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = controller.tabBarItem
        return navigation
    }
    
    //MARK: NTSearchViewControllerDelegate methods
    
    internal func foodSearchViewController(sender: NTFoodSearchViewController, didSelectFood food: NTFood, quantity: Int, measureIndex: Int) {
        self.mealsViewController.presentMealDetailsWithFood(food, quantity: quantity, measureIndex: measureIndex)
        self.selectedIndex = 2
    }
    

}
