//
//  DayView.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol DayViewDataSource: class {
    func dayViewTitleForDay(sender: DayView) -> String
    func dayViewNumberOfNutrients(sender: DayView) -> Int
    func dayView(sender: DayView, titleForNutrientAtIndex index: Int) -> String
    func dayView(sender: DayView, valueForNutrientAtIndex index: Int) -> Float
    func dayView(sender: DayView, unitForNutrientAtIndex index: Int) -> String
}

class DayView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak internal var dataSource: DayViewDataSource?
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultHeaderFont()
        label.textAlignment = .Center
        return label
    }()
    
    lazy private var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(NutrientCell.self, forCellReuseIdentifier: NutrientCell.reuseIdentifier)
        table.registerClass(ActionCell.self, forCellReuseIdentifier: ActionCell.reuseIdentifier)
        return table
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    internal func reloadData() {
        self.titleLabel.text = self.dataSource?.dayViewTitleForDay(self)
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.tableView)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .Bottom)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel, withOffset: 20.0)
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 2
        }
        
        guard let num = self.dataSource?.dayViewNumberOfNutrients(self) else {
            return 0
        }
        
        return num
    }
    
    internal func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {
            return nil
        }
        
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 40.0))
        
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ActionCell.reuseIdentifier) as! ActionCell
            if indexPath.row == 0 {
                cell.title = "View Day Details"
                cell.type = .View
            } else {
                cell.title = "Delete Day"
                cell.type = .Delete
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NutrientCell.reuseIdentifier) as! NutrientCell
            cell.name = self.dataSource?.dayView(self, titleForNutrientAtIndex: indexPath.row)
            cell.value = self.dataSource?.dayView(self, valueForNutrientAtIndex: indexPath.row)
            cell.unit = self.dataSource?.dayView(self, unitForNutrientAtIndex: indexPath.row)
            return cell
        }
        
    }

}
