//
//  NTSearchViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-18.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTSearchViewControllerDelegate: class {
    func searchViewController(sender: NTSearchViewController, didSelectFoodItem foodItem:NTFoodItem)
}

class NTSearchViewController: UIViewController, NTSearchViewDelegate, NTSearchViewDataSource {
    
    weak internal var delegate: NTSearchViewControllerDelegate?
    
    private var foodItems: [NTFoodItem]?
    private var noResults: Bool = false
    
    private let searchProvider: NTSearchProvider = NTSearchProvider(service: NTSearchService())
    private lazy var searchView: NTSearchView = {
        let view: NTSearchView = NTSearchView()
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
        self.view.addSubview(self.searchView)
        
        self.updateViewConstraints()

    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.searchView.autoPinEdgesToSuperviewEdges()
    }
    
    override internal func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    internal func cancelButtonDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: NTSearchViewDataSource methods
    
    internal func searchViewNumberOfFoods(sender: NTSearchView) -> Int {
    
        if self.noResults {
            return 1
        } else if let items: [NTFoodItem] = self.foodItems {
            return items.count
        }
        
        return 0
    }
    
    internal func searchView(sender: NTSearchView, nameForFoodAtIndex index: Int) -> String {
        
        if self.noResults {
            return "No results found"
        } else if let items: [NTFoodItem] = self.foodItems, name: String = items[index].name {
            return name
        }
        return ""
        
    }
    
    // MARK: NTSearchViewDelegate methods

    internal func searchView(sender: NTSearchView, didChangeSearchQuery query: String) {
        if ( query.characters.count >= 3 ) {
            self.searchProvider.fetchFoodItems(query,
                success: { (originalQuery: String, results: [NTFoodItem]) -> Void in
                    if self.searchView.currentQuery == originalQuery {
                        self.foodItems = results
                        self.searchView.reloadData()
                    }
                },
                failure: { (error: ErrorType) -> Void in
                    
                }
            )
        }
    }
    
    internal func searchView(sender: NTSearchView, didSelectFoodAtIndex index: Int) {
        let foodItem: NTFoodItem = self.foodItems![index]
        self.delegate?.searchViewController(self, didSelectFoodItem: foodItem)
    }
    
}

