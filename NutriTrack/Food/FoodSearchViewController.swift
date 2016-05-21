//
//  FoodSearchViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-15.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol FoodSearchViewControllerDelegate: class {
    func foodSearchViewController(sender: FoodSearchViewController, didSelectFood food:Food, quantity: Int, measureIndex: Int)
}

class FoodSearchViewController: BaseViewController, UISearchBarDelegate, SearchResultsViewDelegate, SearchResultsViewDataSource, FoodDetailsViewControllerDelegate {

    weak internal var delegate: FoodSearchViewControllerDelegate?
    
    private var searchFoods: [Food]?
    private var recentFoods: [Food]?
    private var categories: [Category]?
    private var noSearchResults: Bool = false
    
    private let dataManager: FoodManager = FoodManager(provider: FoodProvider())
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Find a food"
        searchBar.barTintColor = UIColor.themeBackgroundColor()
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.borderColor = UIColor.themeBackgroundColor().CGColor
        searchBar.delegate = self;
        return searchBar;
    }()
    
    private lazy var scopesControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            NSLocalizedString("History", comment: ""),
            NSLocalizedString("Categories", comment: "")
        ])
        control.addTarget(self, action: #selector(scopesControlDidTap(_:)), forControlEvents: .ValueChanged)
        return control
    }()
    
    private lazy var statusBarBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.themeBackgroundColor()
        return view
    }()
    
    private lazy var scopedResultsView: SearchResultsView = {
        let view = SearchResultsView(frame: CGRectZero)
        view.tag = 0;
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var foodResultsView: SearchResultsView = {
        let view = SearchResultsView(frame: CGRectZero, blursWhenEmpty: true)
        view.tag = 1;
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.statusBarBackground)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.scopesControl)
        
        self.view.addSubview(self.scopedResultsView)
        self.view.addSubview(self.foodResultsView)
        
        self.setShowsSearchView(false, animated: false)
        self.scopesControl.selectedSegmentIndex = 0
    
        self.updateViewConstraints()
        
        self.dataManager.fetchCategories(
            success: { (results) in
                self.categories = results
                self.scopedResultsView.reloadData()
            },
            failure: { (error) in
                
            }
        )
        
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.statusBarBackground.autoPinEdgeToSuperviewEdge(.Left)
        self.statusBarBackground.autoPinEdgeToSuperviewEdge(.Right)
        self.statusBarBackground.autoPinEdgeToSuperviewEdge(.Top)
        self.statusBarBackground.autoSetDimension(.Height, toSize: 20.0)
        
        self.searchBar.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.statusBarBackground)
        self.searchBar.autoPinEdgeToSuperviewEdge(.Left)
        self.searchBar.autoPinEdgeToSuperviewEdge(.Right)
        
        self.scopesControl.autoPinEdgeToSuperviewEdge(.Left, withInset: 5.0)
        self.scopesControl.autoPinEdgeToSuperviewEdge(.Right, withInset: 5.0)
        self.scopesControl.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.searchBar, withOffset: 5.0)
        
        self.scopedResultsView.autoPinEdgeToSuperviewEdge(.Left)
        self.scopedResultsView.autoPinEdgeToSuperviewEdge(.Right)
        self.scopedResultsView.autoPinEdgeToSuperviewEdge(.Bottom)
        self.scopedResultsView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.scopesControl, withOffset: 2.0)
        
        self.foodResultsView.autoPinEdgeToSuperviewEdge(.Left)
        self.foodResultsView.autoPinEdgeToSuperviewEdge(.Right)
        self.foodResultsView.autoPinEdgeToSuperviewEdge(.Bottom)
        self.foodResultsView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.searchBar)
        
    }
    
    internal func scopesControlDidTap(sender: UISegmentedControl) {
        self.scopedResultsView.reloadData()
    }
    
    internal func setShowsSearchView(showing: Bool, animated: Bool) {
        let duration = animated ? 0.25 : 0.0
        UIView.animateWithDuration(duration) {
            self.foodResultsView.alpha = showing ? 1.0 : 0.0
        }
    }
    
    // MARK: UISearchBarDelegate methods
    
    internal func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.setShowsSearchView(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    internal func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.setShowsSearchView(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    internal func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.setShowsSearchView(false, animated: true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if ( searchText.characters.count >= 3 ) {
            self.dataManager.search(searchText,
                success: { (originalQuery: String, results: [Food]) -> Void in
                    if self.searchBar.text == originalQuery {
                        self.noSearchResults = false
                        self.searchFoods = results
                        self.foodResultsView.reloadData()
                    }
                },
                failure: { (error: ErrorType) -> Void in
                    self.noSearchResults = true
                    self.foodResultsView.reloadData()
                }
            )
        } else {
            self.noSearchResults = false
            self.searchFoods = [Food]()
            self.foodResultsView.reloadData()
        }
    }
    
    // MARK: SearchResultsViewDataSource methods
    
    internal func searchResultsViewNumberOfResults(sender: SearchResultsView) -> Int {
        switch sender.tag {
        case 1:
            return Int.unwrapOrZero(self.searchFoods?.count)
        default:
            if self.scopesControl.selectedSegmentIndex == 0 {
                return 3
            } else {
                return Int.unwrapOrZero(self.categories?.count)
            }
        }
    }
    
    internal func searchResultsView(sender: SearchResultsView, titleForResultAtIndex index: Int) -> String {
        switch sender.tag {
        case 1:
            return String.unwrapOrBlank(self.searchFoods?[index].name)
        default:
            if self.scopesControl.selectedSegmentIndex == 0 {
                return "Recent"
            } else {
                return String.unwrapOrBlank(self.categories?[index].name)
            }
        }
    }
    
    internal func searchResultsView(sender: SearchResultsView, subtitleForResultAtIndex index: Int) -> String? {
        switch sender.tag {
        case 1:
            return String.unwrapOrBlank(self.searchFoods?[index].category)
        default:
            if self.scopesControl.selectedSegmentIndex == 0 {
                return "Recent"
            } else {
                return nil
            }
        }
    }
    
    // MARK: SearchResultsViewDelegate methods
    
    internal func searchResultsView(sender: SearchResultsView, didSelectResultAtIndex index: Int) {
        if sender.tag == 1 || self.scopesControl.selectedSegmentIndex == 0 {
            if let foods = (sender.tag == 1 ? self.searchFoods : self.recentFoods) {
                let controller = FoodDetailsViewController(food: foods[index])
                controller.delegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: FoodDetailsViewDelegate methods
    
    internal func foodDetailsViewController(sender: FoodDetailsViewController, didConfirmFood food: Food, quantity: Int, measureIndex: Int) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.foodSearchViewController(self, didSelectFood: food, quantity: quantity, measureIndex: measureIndex)
    }
    

}
