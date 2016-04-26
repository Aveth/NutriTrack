//
//  NTCompareViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTCompareViewController: UIPageViewController, NTSearchViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private let emptyViewController = NTEmptyViewController()
    private var detailsViewControllers = [NTDetailsViewController]()
    private var selectedIndex = 0
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = NSLocalizedString("Compare Foods", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add Item", comment: ""), style: .Plain, target: self, action: "addItemButtonDidTap:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Clear", comment: ""), style: .Plain, target: self, action: "clearButtonDidTap:")
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.regularFontOfSize(14.0)], forState: .Normal)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setViewControllers([self.emptyViewController], direction: .Forward, animated: true, completion: nil)

    }
    
    internal func addItemButtonDidTap(sender: UIBarButtonItem) {
        let controller = NTSearchViewController()
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
    }
    
    internal func clearButtonDidTap(sender: UIBarButtonItem) {
        self.detailsViewControllers.removeAll()
        self.selectedIndex = 0
        self.setViewControllers([self.emptyViewController], direction: .Forward, animated: true, completion: nil)
    }
    
    // MARK: NTSearchViewControllerDelegate methods
    
    internal func searchViewController(sender: NTSearchViewController, didSelectFoodItem foodItem: NTFoodItem) {
        let controller = NTDetailsViewController(foodItem: foodItem)
        self.detailsViewControllers.append(controller)
        self.selectedIndex = self.detailsViewControllers.count - 1
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.setViewControllers([controller], direction: .Forward, animated: true, completion: nil)
        })
    }
    
    // MARK: UIPageViewControllerDataSource methods
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? NTDetailsViewController, index = self.detailsViewControllers.indexOf(controller) {
            if index < self.detailsViewControllers.count - 1 {
                return self.detailsViewControllers[index + 1]
            }
        }
        return nil
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if let controller = viewController as? NTDetailsViewController, index = self.detailsViewControllers.indexOf(controller) {
            if index > 0 {
                return self.detailsViewControllers[index - 1]
            }
        }
        return nil
    }
    
    internal func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return max(self.detailsViewControllers.count, 1)
    }
    
    internal func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.selectedIndex
    }
    
    // MARK: UIPageViewControllerDelegate methods
    
    internal func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.selectedIndex = previousViewControllers.count
    }
}
