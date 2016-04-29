//
//  ViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTMealsViewController: UIViewController, NTMealDetailsViewControllerDelegate {
    
    internal var dataManager: NTMealsManger = NTMealsManger(provider: NTMealsCoreDataProvider())
    lazy private var emptyView: NTEmptyView = NTEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Your Meals", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Add Meal", comment: ""), style: .Plain, target: self, action: #selector(addMealButtonDidTap(_:)))
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.backgroundColor()
        self.view.addSubview(self.emptyView)
        
        self.updateViewConstraints()
    }
    
    internal func addMealButtonDidTap(sender: UIBarButtonItem) {
        let controller = NTMealDetailsViewController()
        controller.delegate = self
        self.navigationController?.presentViewController(controller)
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
