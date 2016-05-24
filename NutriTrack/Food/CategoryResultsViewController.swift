//
//  CategoryResultsViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-23.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class CategoryResultsViewController: BaseViewController, SearchResultsViewDataSource, SearchResultsViewDelegate, FoodDetailsViewControllerDelegate {

    internal var category: Category
    internal var dataManager: FoodManager
    
    private var foods: [Food]?
    
    lazy private var searchResultsView: SearchResultsView = {
        let view = SearchResultsView(frame: CGRectZero)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy private var spinner: LoadingIndicator = {
        let spinner = LoadingIndicator()
        return spinner
    }()
    
    internal init(category: Category, dataManager: FoodManager) {
        self.category = category
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString(self.category.name, comment: "")
        
        self.view.addSubview(self.searchResultsView)
        self.view.addSubview(self.spinner)
        
        self.updateViewConstraints()
        
        self.spinner.activate()
        self.dataManager.foodsForCategory(self.category.id,
            success: { (results) in
                self.spinner.deactivte()
                self.foods = results
                self.searchResultsView.reloadData()
            },
            failure: { (error) in
                self.spinner.deactivte()
            }
        )
        
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.searchResultsView.autoPinEdgesToSuperviewEdges()
        self.spinner.autoPinEdgesToSuperviewEdges()
    
    }
    
    // MARK: SearchResultsViewDataSource methods
    
    internal func searchResultsViewNumberOfResults(sender: SearchResultsView) -> Int {
        return Int.unwrapOrZero(self.foods?.count)
    }
    
    internal func searchResultsView(sender: SearchResultsView, titleForResultAtIndex index: Int) -> String {
        return String.unwrapOrBlank(self.foods?[index].name)
    }
    
    internal func searchResultsView(sender: SearchResultsView, subtitleForResultAtIndex index: Int) -> String? {
        return String.unwrapOrBlank(self.foods?[index].category)
    }
    
    // MARK: SearchResultsViewDelegate methods
    
    internal func searchResultsView(sender: SearchResultsView, didSelectResultAtIndex index: Int) {
        if let foods = self.foods {
            let controller = FoodDetailsViewController(food: foods[index])
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: FoodDetailsViewControllerDelegate methods
    
    internal func foodDetailsViewController(sender: FoodDetailsViewController, didConfirmFood food: Food, quantity: Int, measureIndex: Int) {
        
    }
    
}
