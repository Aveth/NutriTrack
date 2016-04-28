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
}

protocol NTFoodDetailsViewDataSource: class {
    func foodDetailsViewNameForFood(sender: NTFoodDetailsView) -> String
    
    func foodDetailsViewNumberOfMeasures(sender: NTFoodDetailsView) -> Int
    func foodDetailsView(sender: NTFoodDetailsView, nameForMeasureAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, valueForMeasureAtIndex index: Int) -> Float
    
    func foodDetailsViewNumberOfNutrients(sender: NTFoodDetailsView) -> Int
    func foodDetailsView(sender: NTFoodDetailsView, nameForNutrientAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, unitForNutrientAtIndex index: Int) -> String
    func foodDetailsView(sender: NTFoodDetailsView, valueForNutrientAtIndex index: Int) -> Float
}

class NTFoodDetailsView: UIView, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static private let BaseMeasuresGrams: Float = 100.0
    
    weak internal var delegate: NTFoodDetailsViewDelegate?
    weak internal var dataSource: NTFoodDetailsViewDataSource?
    
    private let reuseIdentifier: String = "cellReuseIdentifier"
    
    lazy private var measurePickerField: NTPickerField = {
        let field = NTPickerField()
        field.text = self.dataSource?.foodDetailsView(self, nameForMeasureAtIndex: 0)
        field.title = NSLocalizedString("Measure:", comment: "")
        field.inputView = self.pickerView
        return field
    }()
    
    lazy private var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
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
        label.text = self.dataSource?.foodDetailsViewNameForFood(self)
        label.textAlignment = .Center
        label.font = UIFont.boldFontOfSize(22.0)
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
        self.addSubview(self.measurePickerField)
        self.addSubview(self.tableView)
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0), excludingEdge: .Bottom)
        
        self.measurePickerField.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        self.measurePickerField.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        self.measurePickerField.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel, withOffset: 10.0)
        self.measurePickerField.autoSetDimension(.Height, toSize: 80.0)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.measurePickerField, withOffset: 5.0)
        
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
        self.pickerView.reloadAllComponents()
        self.measurePickerField.text = self.dataSource?.foodDetailsView(self, nameForMeasureAtIndex: 0)
        self.titleLabel.text = self.dataSource?.foodDetailsViewNameForFood(self)
        self.setNeedsUpdateConstraints()
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.dataSource?.foodDetailsViewNumberOfNutrients(self) {
            return num
        }
        return 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! NTFoodDetailsViewCell
        if let ds = self.dataSource {
            
            let nutrientValue = ds.foodDetailsView(self, valueForNutrientAtIndex: indexPath.row)
            let measureValue = ds.foodDetailsView(self, valueForMeasureAtIndex: self.pickerView.selectedRowInComponent(0))
            let adjustedNutrientValue = (nutrientValue / NTFoodDetailsView.BaseMeasuresGrams) * measureValue
            
            cell.name = ds.foodDetailsView(self, nameForNutrientAtIndex: indexPath.row)
            cell.unit = ds.foodDetailsView(self, unitForNutrientAtIndex: indexPath.row)
            cell.value = adjustedNutrientValue
            
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
        if let num = self.dataSource?.foodDetailsViewNumberOfMeasures(self) {
            return num
        }
        return 0
    }
    
    internal func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let title = self.dataSource?.foodDetailsView(self, nameForMeasureAtIndex: row) {
            return title
        }
        return nil
    }
    
    // MARK: UIPickerViewDelegate methods
    
    internal func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let title = self.dataSource?.foodDetailsView(self, nameForMeasureAtIndex: row) {
            self.measurePickerField.text = title
            self.delegate?.foodDetailsView(self, didSelectMeasureAtIndex: row)
            self.tableView.reloadData()
        }
    }
    
}
