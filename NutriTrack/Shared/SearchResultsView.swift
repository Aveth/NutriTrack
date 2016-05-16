//
//  SearchResultsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-19.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import PureLayout

protocol SearchResultsViewDelegate: class {
    func searchResultsView(sender: SearchResultsView, didSelectResultAtIndex index: Int)
}

protocol SearchResultsViewDataSource: class {
    func searchResultsView(sender: SearchResultsView, titleForResultAtIndex index: Int) -> String
    func searchResultsViewNumberOfFoods(sender: SearchResultsView) -> Int
}

class SearchResultsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var delegate: SearchResultsViewDelegate?
    weak internal var dataSource: SearchResultsViewDataSource?
    
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return table
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.addSubview(self.tableView)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        self.layoutMargins = UIEdgeInsetsZero
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.searchResultsView(self, didSelectResultAtIndex: indexPath.row)
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.unwrapOrZero(dataSource?.searchResultsViewNumberOfFoods(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchResultCell.reuseIdentifier) as! SearchResultCell
        cell.textLabel?.text = self.dataSource!.searchResultsView(self, titleForResultAtIndex: indexPath.row)
        
        return cell
    }

}
