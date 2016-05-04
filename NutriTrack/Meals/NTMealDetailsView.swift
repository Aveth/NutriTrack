//
//  NTMealDetailsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTMealDetailsViewDelegate: class {
    func mealDetailsView(sender: NTMealDetailsView, didChangeDateForMeal date: NSDate)
}

protocol NTMealDetailsViewDataSource: class {
    func mealDetailsViewNumberOfFoods(sender: NTMealDetailsView) -> Int
    func mealDetailsView(sender: NTMealDetailsView, titleForFoodAtIndex index: Int) -> String
    func mealDetailsViewDateForMeal(sender: NTMealDetailsView) -> NSDate
}

class NTMealDetailsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak internal var dataSource: NTMealDetailsViewDataSource?
    weak internal var delegate: NTMealDetailsViewDelegate?
    
    private lazy var dateTimePickerField: NTLabeledField = {
        let field = NTLabeledField()
        field.title = NSLocalizedString("Date/Time:", comment: "")
        field.text = self.dateFormatter.stringFromDate(NSDate())
        field.inputView = self.dateTimePicker
        return field
    }()
    
    private lazy var dateTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(dateTimePickerDidChange(_:)), forControlEvents: .ValueChanged)
        return picker
    }()
    
    private lazy var tableView: UITableView = {
        let table: UITableView = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: String.defaultCellReuseIdentifier())
        return table
    }()
    
    private lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }()

    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.addSubview(self.dateTimePickerField)
        self.addSubview(self.tableView)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                
        self.dateTimePickerField.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), excludingEdge: .Bottom)
        self.dateTimePickerField.autoSetDimension(.Height, toSize: 40.0)
        
        self.tableView.autoPinEdgeToSuperviewEdge(.Left)
        self.tableView.autoPinEdgeToSuperviewEdge(.Right)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.dateTimePickerField)
        self.tableView.autoSetDimension(.Height, toSize: 300.0)
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
        if let date = self.dataSource?.mealDetailsViewDateForMeal(self) {
            self.dateTimePickerField.text = self.dateFormatter.stringFromDate(date)
        } else {
            self.dateTimePickerField.text = self.dateFormatter.stringFromDate(NSDate())
        }
    }
    
    internal func selectFoodAtIndex(index: Int) {
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Bottom)
    }
    
    internal func dateTimePickerDidChange(sender: UIDatePicker) {
        self.dateTimePickerField.text = self.dateFormatter.stringFromDate(sender.date)
        self.delegate?.mealDetailsView(self, didChangeDateForMeal: sender.date)
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.unwrapOrZero(self.dataSource?.mealDetailsViewNumberOfFoods(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String.defaultCellReuseIdentifier())
        cell?.textLabel?.text = self.dataSource!.mealDetailsView(self, titleForFoodAtIndex: indexPath.row)
        cell?.textLabel?.font = UIFont.defaultFont()
        return cell!
    }


}
