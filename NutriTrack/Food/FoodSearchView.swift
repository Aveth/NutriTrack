//
//  FoodSearchView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import PureLayout

protocol FoodSearchViewDelegate: class {
    func foodSearchView(sender: FoodSearchView, didChangeSearchQuery query: String)
    func foodSearchView(sender: FoodSearchView, didSelectFoodAtIndex index: Int)
}

protocol FoodSearchViewDataSource: class {
    func foodSearchView(sender: FoodSearchView, titleForFoodAtIndex index: Int) -> String
    func foodSearchViewNumberOfFoods(sender: FoodSearchView) -> Int
}

class FoodSearchView: UIView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var delegate: FoodSearchViewDelegate?
    weak internal var dataSource: FoodSearchViewDataSource?
    
    internal var currentQuery: String? {
        get {
            return self.searchBar.text
        }
    }
    
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: String.defaultCellReuseIdentifier())
        return table
    }()
    lazy private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = NSLocalizedString("Search for a food item", comment: "")
        bar.showsCancelButton = true
        return bar
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.addSubview(self.searchBar)
        self.addSubview(self.tableView)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.searchBar.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.searchBar)
        
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: UISearchBarDelegate methods
    
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.foodSearchView(self, didChangeSearchQuery: searchText)
    }
    
    internal func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.foodSearchView(self, didSelectFoodAtIndex: indexPath.row)
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.unwrapOrZero(dataSource?.foodSearchViewNumberOfFoods(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String.defaultCellReuseIdentifier())
        cell?.textLabel?.text = self.dataSource!.foodSearchView(self, titleForFoodAtIndex: indexPath.row)
        cell?.textLabel?.font = UIFont.defaultFont()
        cell?.textLabel?.textColor = UIColor.defaultTextColor()
        return cell!
    }

}
