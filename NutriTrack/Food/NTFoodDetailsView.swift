//
//  NTFoodDetailsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-22.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTFoodDetailsViewDelegate: class {
    func foodDetailsView(sender: NTFoodDetailsView, didSelectMeasureAtIndex index: Int)
    func foodDetailsView(sender: NTFoodDetailsView, didSelectQuantityAtIndex index: Int)
}

protocol NTFoodDetailsViewDataSource: class {
    func foodDetailsViewTitleForFood(sender: NTFoodDetailsView) -> String
    
    func foodDetailsViewNumberOfMeasures(sender: NTFoodDetailsView) -> Int
    func foodDetailsView(sender: NTFoodDetailsView, titleForMeasureAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, valueForMeasureAtIndex index: Int) -> Float
    func foodDetailsViewIndexForSelectedMeasure(sender: NTFoodDetailsView) -> Int
    
    func foodDetailsViewNumberOfNutrients(sender: NTFoodDetailsView) -> Int
    func foodDetailsView(sender: NTFoodDetailsView, titleForNutrientAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, unitForNutrientAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, valueForNutrientAtIndex index: Int) -> Float
    
    func foodDetailsViewNumberOfQuantities(sender: NTFoodDetailsView) -> Int
    func foodDetailsView(sender: NTFoodDetailsView, valueForQuantityAtIndex index: Int) -> Int
    func foodDetailsViewIndexForSelectedQuantity(sender: NTFoodDetailsView) -> Int
}

class NTFoodDetailsView: UIView, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak internal var delegate: NTFoodDetailsViewDelegate?
    weak internal var dataSource: NTFoodDetailsViewDataSource?
    
    private let reuseIdentifier: String = "cellReuseIdentifier"
    
    lazy private var quantityField: NTLabeledField = {
        let field = NTLabeledField()
        field.title = NSLocalizedString("Quantity:", comment: "")
        field.inputView = self.quantityPickerView
        return field
    }()
    
    lazy private var quantityPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 0
        return picker
    }()
    
    lazy private var measurePickerField: NTLabeledField = {
        let field = NTLabeledField()
        field.title = NSLocalizedString("Measure:", comment: "")
        field.inputView = self.measurePickerView
        return field
    }()
    
    lazy private var measurePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 1
        return picker
    }()
    
    lazy private var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(NTFoodDetailsViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        return table
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.dataSource?.foodDetailsViewTitleForFood(self)
        label.textAlignment = .Center
        label.font = UIFont.defaultHeaderFont()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        return label
    }()

    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.quantityField)
        self.addSubview(self.measurePickerField)
        self.addSubview(self.tableView)
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 10.0, bottom: 30.0, right: 10.0), excludingEdge: .Bottom)
        
        self.quantityField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        self.quantityField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        self.quantityField.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel, withOffset: 10.0)
        self.quantityField.autoSetDimension(.Height, toSize: 35.0)
        
        self.measurePickerField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        self.measurePickerField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        self.measurePickerField.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.quantityField, withOffset: 5.0)
        self.measurePickerField.autoSetDimension(.Height, toSize: 35.0)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.measurePickerField, withOffset: 20.0)
        
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
        self.quantityPickerView.reloadAllComponents()
        self.measurePickerView.reloadAllComponents()
        if let index = self.dataSource?.foodDetailsViewIndexForSelectedMeasure(self) {
            self.measurePickerField.text = self.dataSource?.foodDetailsView(self, titleForMeasureAtIndex: index)
        } else {
            self.measurePickerField.text = self.dataSource?.foodDetailsView(self, titleForMeasureAtIndex: 0)
        }
        if let
            index = self.dataSource?.foodDetailsViewIndexForSelectedQuantity(self),
            value = self.dataSource?.foodDetailsView(self, valueForQuantityAtIndex: index)
        {
            self.quantityField.text = String(value)
        } else if let value = self.dataSource?.foodDetailsView(self, valueForQuantityAtIndex: 0) {
            self.quantityField.text = String(value)
        }
        self.titleLabel.text = self.dataSource?.foodDetailsViewTitleForFood(self)
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.unwrapOrZero(self.dataSource?.foodDetailsViewNumberOfNutrients(self))
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! NTFoodDetailsViewCell
        if let ds = self.dataSource {
            cell.name = ds.foodDetailsView(self, titleForNutrientAtIndex: indexPath.row)
            cell.unit = ds.foodDetailsView(self, unitForNutrientAtIndex: indexPath.row)
            cell.value = ds.foodDetailsView(self, valueForNutrientAtIndex: indexPath.row)
        }
        return cell
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: UIPickerViewDataSource methods
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return Int.unwrapOrZero(self.dataSource?.foodDetailsViewNumberOfQuantities(self))
        }
        return Int.unwrapOrZero(self.dataSource?.foodDetailsViewNumberOfMeasures(self))
    }
    
    internal func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            guard let quantity = self.dataSource?.foodDetailsView(self, valueForQuantityAtIndex: row)
            else {
                return nil
            }
            return String(quantity)
        } else {
            guard let title = self.dataSource?.foodDetailsView(self, titleForMeasureAtIndex: row)
            else {
               return nil
            }
            return title
        }
    }
    
    // MARK: UIPickerViewDelegate methods
    
    internal func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            if let quantity = self.dataSource?.foodDetailsView(self, valueForQuantityAtIndex: row) {
                self.quantityField.text = String(quantity)
                self.delegate?.foodDetailsView(self, didSelectQuantityAtIndex: row)
                self.tableView.reloadData()
            }
        } else {
            if let title = self.dataSource?.foodDetailsView(self, titleForMeasureAtIndex: row) {
                self.measurePickerField.text = title
                self.delegate?.foodDetailsView(self, didSelectMeasureAtIndex: row)
                self.tableView.reloadData()
            }
        }
    }
    
}
