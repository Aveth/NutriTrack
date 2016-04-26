//
//  NTSearchView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import PureLayout

protocol NTSearchViewDelegate: class {
    func searchView(sender: NTSearchView, didChangeSearchQuery query: String)
    func searchView(sender: NTSearchView, didSelectFoodAtIndex index: Int)
}

protocol NTSearchViewDataSource: class {
    func searchView(sender: NTSearchView, nameForFoodAtIndex index: Int) -> String
    func searchViewNumberOfFoods(sender: NTSearchView) -> Int
}

class NTSearchView: UIView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var delegate: NTSearchViewDelegate?
    weak internal var dataSource: NTSearchViewDataSource?
    
    internal var currentQuery: String? {
        get {
            return self.searchBar.text
        }
    }
    
    private let reuseIdentifier: String = "cellReuseIdentifier"
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        return table
    }()
    lazy private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.placeholder = NSLocalizedString("Search for a food item!", comment: "")
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
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.searchBar.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.searchBar)
        
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: UISearchBarDelegate methods
    
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.searchView(self, didChangeSearchQuery: searchText)
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.searchView(self, didSelectFoodAtIndex: indexPath.row)
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.searchViewNumberOfFoods(self)
        }
        return 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier)
        cell?.textLabel?.text = self.dataSource!.searchView(self, nameForFoodAtIndex: indexPath.row)
        return cell!
    }

}
