//
//  NTCompareViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTCompareViewController: UIPageViewController, NTFoodSearchViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var foodDetailsViewControllers = [NTFoodDetailsViewController]()
    private var selectedIndex = 0
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = NSLocalizedString("Compare Foods", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add Item", comment: ""), style: .Plain, target: self, action: "addItemButtonDidTap:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: ""), style: .Plain, target: self, action: "clearButtonDidTap:")
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    internal func addItemButtonDidTap(sender: UIBarButtonItem) {
        let controller = NTFoodSearchViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
    
    internal func clearButtonDidTap(sender: UIBarButtonItem) {
        self.foodDetailsViewControllers.removeAll()
        self.selectedIndex = 0
    }
    
    // MARK: NTFoodSearchViewControllerDelegate methods
    
    internal func foodSearchViewController(sender: NTFoodSearchViewController, didSelectFood food: NTFood) {
        let controller = NTFoodDetailsViewController(food: food)
        self.foodDetailsViewControllers.append(controller)
        self.selectedIndex = self.foodDetailsViewControllers.count - 1
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.setViewControllers([controller], direction: .Forward, animated: true, completion: nil)
        })
    }
    
    // MARK: UIPageViewControllerDataSource methods
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? NTFoodDetailsViewController, index = self.foodDetailsViewControllers.indexOf(controller) {
            if index < self.foodDetailsViewControllers.count - 1 {
                return self.foodDetailsViewControllers[index + 1]
            }
        }
        return nil
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? NTFoodDetailsViewController, index = self.foodDetailsViewControllers.indexOf(controller) {
            if index > 0 {
                return self.foodDetailsViewControllers[index - 1]
            }
        }
        return nil
    }
    
    internal func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return max(self.foodDetailsViewControllers.count, 1)
    }
    
    internal func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.selectedIndex
    }
    
    // MARK: UIPageViewControllerDelegate methods
    
    internal func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.selectedIndex = previousViewControllers.count
    }
}
