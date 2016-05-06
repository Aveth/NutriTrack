//
//  NTMealDayView.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTMealDayViewDataSource: class {
    func mealDayViewTitleForDay(sender: NTMealDayView) -> String
    func mealDayViewNumberOfNutrients(sender: NTMealDayView) -> Int
    func mealDayView(sender: NTMealDayView, titleForNutrientAtIndex index: Int) -> String
    func mealDayView(sender: NTMealDayView, valueForNutrientAtIndex index: Int) -> Float
    func mealDayView(sender: NTMealDayView, unitForNutrientAtIndex index: Int) -> String
}

class NTMealDayView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak internal var dataSource: NTMealDayViewDataSource?
    
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
        table.registerClass(NTFoodDetailsViewCell.self, forCellReuseIdentifier: String.defaultCellReuseIdentifier())
        return table
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    internal func reloadData() {
        self.titleLabel.text = self.dataSource?.mealDayViewTitleForDay(self)
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
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.dataSource?.mealDayViewNumberOfNutrients(self) {
            return num
        }
        return 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String.defaultCellReuseIdentifier()) as! NTFoodDetailsViewCell
        cell.name = self.dataSource?.mealDayView(self, titleForNutrientAtIndex: indexPath.row)
        cell.value = self.dataSource?.mealDayView(self, valueForNutrientAtIndex: indexPath.row)
        cell.unit = self.dataSource?.mealDayView(self, unitForNutrientAtIndex: indexPath.row)
        return cell
    }

}
