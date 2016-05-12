//
//  MealDetailsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol MealsViewDataSource: class {
    func mealsViewNumberOfMeals(sender: MealsView) -> Int
    func mealsView(sender: MealsView, titleForMealAtIndex index: Int) -> String
}

class MealsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var dataSource: MealsViewDataSource?
    
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
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.autoPinEdgesToSuperviewEdges()
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
        return Int.unwrapOrZero(self.dataSource?.mealsViewNumberOfMeals(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String.defaultCellReuseIdentifier())
        cell?.textLabel?.text = self.dataSource!.mealsView(self, titleForMealAtIndex: indexPath.row)
        cell?.textLabel?.font = UIFont.defaultFont()
        return cell!
    }
    
    
}
