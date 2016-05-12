//
//  FoodSearchViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-18.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol FoodSearchViewControllerDelegate: class {
    func foodSearchViewController(sender: FoodSearchViewController, didSelectFood food:Food, quantity: Int, measureIndex: Int)
}

class FoodSearchViewController: BaseViewController, FoodSearchViewDelegate, FoodSearchViewDataSource, FoodDetailsViewControllerDelegate {
    
    weak internal var delegate: FoodSearchViewControllerDelegate?
    internal var completeText: String = NSLocalizedString("Done", comment: "")
    
    private var foods: [Food]?
    private var noResults: Bool = false
    
    private let searchProvider: SearchProvider = SearchProvider(service: SearchService())
    private lazy var foodSearchView: FoodSearchView = {
        let view: FoodSearchView = FoodSearchView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitle = NSLocalizedString("Food Search", comment: "")
        self.view.addSubview(self.foodSearchView)
    
        self.updateViewConstraints()
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.foodSearchView.autoPinEdgesToSuperviewEdges()
    }
    
    override internal func leftBarButtonDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: FoodSearchViewDataSource methods
    
    internal func foodSearchViewNumberOfFoods(sender: FoodSearchView) -> Int {
    
        if self.noResults {
            return 1
        } else if let items: [Food] = self.foods {
            return items.count
        }
        
        return 0
    }
    
    internal func foodSearchView(sender: FoodSearchView, titleForFoodAtIndex index: Int) -> String {
        
        if self.noResults {
            return NSLocalizedString("No results found", comment: "")
        } else if let items: [Food] = self.foods, name: String = items[index].name {
            return name
        }
        return ""
        
    }
    
    // MARK: FoodSearchViewDelegate methods

    internal func foodSearchView(sender: FoodSearchView, didChangeSearchQuery query: String) {
        if ( query.characters.count >= 3 ) {
            self.searchProvider.fetchFoods(query,
                success: { (originalQuery: String, results: [Food]) -> Void in
                    if self.foodSearchView.currentQuery == originalQuery {
                        self.noResults = false
                        self.foods = results
                        self.foodSearchView.reloadData()
                    }
                },
                failure: { (error: ErrorType) -> Void in
                    self.noResults = true
                    self.foodSearchView.reloadData()
                }
            )
        } else {
            self.noResults = false
            self.foods = [Food]()
            self.foodSearchView.reloadData()
        }
    }
    
    internal func foodSearchView(sender: FoodSearchView, didSelectFoodAtIndex index: Int) {
        if ( self.noResults ) {
            return
        }
        let food: Food = self.foods![index]
        let controller = FoodDetailsViewController(food: food)
        controller.delegate = self
        controller.completeText = self.completeText
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: FoodDetailsViewControllerDelegate methods
    
    internal func foodDetailsViewController(sender: FoodDetailsViewController, didConfirmFood food: Food, quantity: Int, measureIndex: Int) {
        self.delegate?.foodSearchViewController(self, didSelectFood: food, quantity: quantity, measureIndex: measureIndex)
    }
    
    
    
}

