//
//  NTMealDetailsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTMealsViewDataSource: class {
    func mealsViewNumberOfMeals(sender: NTMealsView) -> Int
    func mealsView(sender: NTMealsView, titleForMealAtIndex index: Int) -> String
}

class NTMealsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var dataSource: NTMealsViewDataSource?
    
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: String.defaultCellReuseIdentifier())
        return table
        }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
    }
    
    private func buildView() {
        self.addSubview(self.tableView)
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.dataSource?.mealsViewNumberOfMeals(self) {
            return num
        }
        return 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String.defaultCellReuseIdentifier())
        cell?.textLabel?.text = self.dataSource!.mealsView(self, titleForMealAtIndex: indexPath.row)
        cell?.textLabel?.font = UIFont.defaultFont()
        return cell!
    }
    
    
}
