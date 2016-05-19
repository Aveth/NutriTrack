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
    func searchResultsViewNumberOfResults(sender: SearchResultsView) -> Int
    func searchResultsView(sender: SearchResultsView, titleForResultAtIndex index: Int) -> String
    func searchResultsView(sender: SearchResultsView, subtitleForResultAtIndex index: Int) -> String?
}

class SearchResultsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var delegate: SearchResultsViewDelegate?
    weak internal var dataSource: SearchResultsViewDataSource?
    
    internal var blursWhenEmpty: Bool
    
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 100.0
        table.registerClass(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return table
    }()
    
    private lazy var overlay: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    internal init(frame: CGRect, blursWhenEmpty blurs: Bool = false) {
        self.blursWhenEmpty = blurs
        super.init(frame: frame)
        self.buildView()
    }

    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        if self.blursWhenEmpty {
            self.addSubview(self.overlay)
            self.tableView.alpha = 0.0
        }
        self.addSubview(self.tableView)
        
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        self.layoutMargins = UIEdgeInsetsZero
        if self.blursWhenEmpty {
            self.overlay.autoPinEdgesToSuperviewEdges()
        }
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
        
        guard self.blursWhenEmpty else {
            return
        }
        
        UIView.animateWithDuration(0.1) {
            if let
                num = self.dataSource?.searchResultsViewNumberOfResults(self)
                where num > 0
            {
                self.tableView.alpha = 1.0
            } else {
                self.tableView.alpha = 0.0
            }
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.searchResultsView(self, didSelectResultAtIndex: indexPath.row)
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.unwrapOrZero(dataSource?.searchResultsViewNumberOfResults(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchResultCell.reuseIdentifier) as! SearchResultCell
        cell.title = self.dataSource!.searchResultsView(self, titleForResultAtIndex: indexPath.row)
        cell.subtitle = self.dataSource!.searchResultsView(self, subtitleForResultAtIndex: indexPath.row)
        return cell
    }

}
