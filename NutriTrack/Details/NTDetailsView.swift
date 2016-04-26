//
//  NTDetailsView.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-22.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

protocol NTDetailsViewDelegate: class {
    
}

protocol NTDetailsViewDataSource: class {
    func detailsViewNameForFood(sender: NTDetailsView) -> String
    
    func detailsViewNumberOfMeasures(sender: NTDetailsView) -> Int
    func detailsView(sender: NTDetailsView, nameForMeasureAtIndex index: Int) -> String
    func detailsView(sender: NTDetailsView, valueForMeasureAtIndex index: Int) -> Float
    
    func detailsViewNumberOfNutrients(sender: NTDetailsView) -> Int
    func detailsView(sender: NTDetailsView, nameForNutrientAtIndex index: Int) -> String
    func detailsView(sender: NTDetailsView, unitForNutrientAtIndex index: Int) -> String
    func detailsView(sender: NTDetailsView, valueForNutrientAtIndex index: Int) -> Float
}

class NTDetailsView: UIView, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private static let BaseMeasuresGrams: Float = 100.0
    
    weak internal var delegate: NTDetailsViewDelegate?
    weak internal var dataSource: NTDetailsViewDataSource?
    
    private let reuseIdentifier: String = "cellReuseIdentifier"
    lazy private var measureWrapper: UIView = {
        let view = UIView()
        view.addSubview(self.measureTitleLabel)
        view.addSubview(self.measureTextField)
        return view
    }()
    lazy private var measureTitleLabel: UILabel = {
       let label = UILabel()
        label.text = NSLocalizedString("Measure:", comment: "")
        return label
    }()
    lazy private var dropdownButton: UIButton = {
        let image = UIImage(named: "dropdown_arrow")
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
        button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: "dropdownButtonDidTap:", forControlEvents: .TouchUpInside)
        return button
    }()
    lazy private var measureTextField: UITextField = {
       let field = UITextField()
        field.text = self.dataSource?.detailsView(self, nameForMeasureAtIndex: 0)
        field.layer.borderWidth = 1.0
        field.layer.cornerRadius = 5.0
        field.leftViewMode = .Always
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        field.rightViewMode = .Always
        field.rightView = self.dropdownButton
        field.delegate = self
        field.inputView = self.pickerView
        field.inputAccessoryView = self.pickerToolbar
        return field
    }()
    lazy private var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    lazy private var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .Done, target: self, action: "pickerToolbarDidComplete:")
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        toolbar.backgroundColor = UIColor.grayColor()
        return toolbar
    }()
    lazy private var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30.0
        table.rowHeight = UITableViewAutomaticDimension
        table.registerClass(NTDetailsViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        return table
    }()
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.dataSource?.detailsViewNameForFood(self)
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(24.0)
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
        self.addSubview(self.measureWrapper)
        self.addSubview(self.tableView)
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.titleLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0), excludingEdge: .Bottom)
        
        self.measureWrapper.autoPinEdgeToSuperviewEdge(.Left, withInset: 10.0)
        self.measureWrapper.autoPinEdgeToSuperviewEdge(.Right, withInset: 10.0)
        self.measureWrapper.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel, withOffset: 10.0)
        self.measureWrapper.autoSetDimension(.Height, toSize: 80.0)
        
        self.measureTitleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.measureTitleLabel.autoSetDimension(.Width, toSize: 90.0)
        
        self.measureTextField.autoPinEdgeToSuperviewMargin(.Right)
        self.measureTextField.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        self.measureTextField.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20.0)
        self.measureTextField.autoPinEdge(.Left, toEdge: .Right, ofView: self.measureTitleLabel)
        
        self.tableView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.tableView.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.measureTextField, withOffset: 5.0)
        
        self.pickerToolbar.autoSetDimension(.Height, toSize: 35.0)
        
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
        self.pickerView.reloadAllComponents()
        self.measureTextField.text = self.dataSource?.detailsView(self, nameForMeasureAtIndex: 0)
        self.titleLabel.text = self.dataSource?.detailsViewNameForFood(self)
        self.setNeedsUpdateConstraints()
    }
    
    internal func pickerToolbarDidComplete(sender: UIBarButtonItem) {
        self.measureTextField.resignFirstResponder()
    }
    
    internal func dropdownButtonDidTap(sender: UIButton) {
        self.measureTextField.becomeFirstResponder()
    }
    
    // MARK: UITableViewDataSource methods
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = self.dataSource?.detailsViewNumberOfNutrients(self) {
            return num
        }
        return 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as! NTDetailsViewCell
        if let ds = self.dataSource {
            
            let nutrientValue = ds.detailsView(self, valueForNutrientAtIndex: indexPath.row)
            let measureValue = ds.detailsView(self, valueForMeasureAtIndex: self.pickerView.selectedRowInComponent(0))
            let adjustedNutrientValue = (nutrientValue / NTDetailsView.BaseMeasuresGrams) * measureValue
            
            cell.name = ds.detailsView(self, nameForNutrientAtIndex: indexPath.row)
            cell.unit = ds.detailsView(self, unitForNutrientAtIndex: indexPath.row)
            cell.value = adjustedNutrientValue
            
        }
        return cell
    }
    
    // MARK: UITableViewDelegate methods
    
    internal func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // MARK: UITextFieldDelegate methods

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // MARK: UIPickerViewDataSource methods
    
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let num = self.dataSource?.detailsViewNumberOfMeasures(self) {
            return num
        }
        return 0
    }
    
    internal func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let title = self.dataSource?.detailsView(self, nameForMeasureAtIndex: row) {
            return title
        }
        return nil
    }
    
    // MARK: UIPickerViewDelegate methods
    
    internal func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let title = self.dataSource?.detailsView(self, nameForMeasureAtIndex: row) {
            self.measureTextField.text = title
            self.tableView.reloadData()
        }
    }
    
}
