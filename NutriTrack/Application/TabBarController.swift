//
//  TabBarControllerViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-30.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, FoodSearchViewControllerDelegate {
    
    lazy private var recipesViewController: RecipesViewController = {
        let controller = RecipesViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Recipes", comment: ""), image: UIImage(named: "cutting_board")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var searchViewController: FoodSearchViewController = {
        let controller = FoodSearchViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Search", comment: ""), image: UIImage(named: "search")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var diaryViewController: DiaryViewController = {
        let controller = DiaryViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Diary", comment: ""), image: UIImage(named: "log_book")?.imageWithRenderingMode(.AlwaysTemplate), selectedImage: nil)
        return controller
    }()
    
    lazy private var profileViewController: ProfileViewController = {
        let controller = ProfileViewController()
        controller.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "profile"), selectedImage: nil)
        return controller
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [
            self.navigationControllerWithViewController(self.recipesViewController),
            self.navigationControllerWithViewController(self.searchViewController),
            self.navigationControllerWithViewController(self.diaryViewController),
            self.navigationControllerWithViewController(self.profileViewController)
        ]
        
        self.searchViewController.delegate = self
    
    }
    
    private func navigationControllerWithViewController(controller: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = controller.tabBarItem
        return navigation
    }
    
    //MARK: SearchViewControllerDelegate methods
    
    internal func foodSearchViewController(sender: FoodSearchViewController, didSelectFood food: Food, quantity: Int, measureIndex: Int) {
        self.diaryViewController.presentMealDetailsWithFood(food, quantity: quantity, measureIndex: measureIndex)
        self.selectedIndex = 2
    }
    

}
