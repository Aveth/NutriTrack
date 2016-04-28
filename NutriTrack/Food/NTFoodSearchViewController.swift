//
//  NTFoodSearchViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-18.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTFoodSearchViewControllerDelegate: class {
    func foodSearchViewController(sender: NTFoodSearchViewController, didSelectFood food:NTFood)
}

class NTFoodSearchViewController: UIViewController, NTFoodSearchViewDelegate, NTFoodSearchViewDataSource, NTFoodDetailsViewControllerDelegate {
    
    weak internal var delegate: NTFoodSearchViewControllerDelegate?
    
    private var foods: [NTFood]?
    private var noResults: Bool = false
    
    private let searchProvider: NTSearchProvider = NTSearchProvider(service: NTSearchService())
    private lazy var foodSearchView: NTFoodSearchView = {
        let view: NTFoodSearchView = NTFoodSearchView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = NSLocalizedString("Food Search", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: "cancelButtonDidTap:")
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.foodSearchView)
        
        self.updateViewConstraints()

    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.foodSearchView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func cancelButtonDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: NTFoodSearchViewDataSource methods
    
    internal func foodSearchViewNumberOfFoods(sender: NTFoodSearchView) -> Int {
    
        if self.noResults {
            return 1
        } else if let items: [NTFood] = self.foods {
            return items.count
        }
        
        return 0
    }
    
    internal func foodSearchView(sender: NTFoodSearchView, nameForFoodAtIndex index: Int) -> String {
        
        if self.noResults {
            return "No results found"
        } else if let items: [NTFood] = self.foods, name: String = items[index].name {
            return name
        }
        return ""
        
    }
    
    // MARK: NTFoodSearchViewDelegate methods

    internal func foodSearchView(sender: NTFoodSearchView, didChangeSearchQuery query: String) {
        if ( query.characters.count >= 3 ) {
            self.searchProvider.fetchFoods(query,
                success: { (originalQuery: String, results: [NTFood]) -> Void in
                    if self.foodSearchView.currentQuery == originalQuery {
                        self.foods = results
                        self.foodSearchView.reloadData()
                    }
                },
                failure: { (error: ErrorType) -> Void in
                    
                }
            )
        }
    }
    
    internal func foodSearchView(sender: NTFoodSearchView, didSelectFoodAtIndex index: Int) {
        let food: NTFood = self.foods![index]
        let controller = NTFoodDetailsViewController(food: food)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: NTFoodDetailsViewControllerDelegate methods
    
    internal func foodDetailsViewController(sender: NTFoodDetailsViewController, didConfirmFood food: NTFood) {
        self.delegate?.foodSearchViewController(self, didSelectFood: food)
    }
    
    
    
}

