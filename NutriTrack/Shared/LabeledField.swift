//
//  DropdownField.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class LabeledField: UIView, UITextFieldDelegate {

    internal var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    internal var text: String? {
        get {
            return self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    internal var showsDropdownButton: Bool {
        get {
            return !self.dropdownButton.hidden
        }
        set {
            self.dropdownButton.hidden = !newValue
        }
    }
    
    override internal var inputView: UIView? {
        get {
            return self.textField.inputView
        }
        set {
            if let view = newValue {
                if view.isKindOfClass(UIPickerView.self) || view.isKindOfClass(UIDatePicker.self) {
                    self.showsDropdownButton = true
                }
            }
            self.textField.inputView = newValue
        }
    }
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont()
        return label
    }()
    
    lazy private var textField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGrayColor().CGColor
        field.layer.cornerRadius = 5.0
        field.leftViewMode = .Always
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        field.rightViewMode = .Always
        field.rightView = self.dropdownButton
        field.delegate = self
        field.inputAccessoryView = self.pickerToolbar
        field.font = UIFont.defaultFont()
        field.backgroundColor = UIColor.tabBarBackgroundColor()
        return field
    }()
    
    lazy private var dropdownButton: UIButton = {
        let image = UIImage(named: "down_arrow")
        let button = UIButton()
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: #selector(dropdownButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        button.hidden = true
        button.backgroundColor = UIColor.themeBackgroundColor()
        return button
    }()
    
    lazy private var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .Done, target: self, action: #selector(pickerToolbarDidComplete(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        toolbar.backgroundColor = UIColor.grayColor()
        return toolbar
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.textField)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.layoutMargins = UIEdgeInsetsZero
        
        self.titleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.titleLabel.autoSetDimension(.Width, toSize: 80.0)
        
        self.textField.autoPinEdgeToSuperviewMargin(.Right)
        self.textField.autoPinEdgeToSuperviewEdge(.Top)
        self.textField.autoPinEdgeToSuperviewEdge(.Bottom)
        self.textField.autoPinEdge(.Left, toEdge: .Right, ofView: self.titleLabel)
        
        self.pickerToolbar.autoSetDimension(.Height, toSize: 35.0)
        
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        let inset = height / 3
        self.dropdownButton.frame = CGRect(x: self.textField.frame.width - height, y: 0.0, width: height, height: height)
        self.dropdownButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    internal func pickerToolbarDidComplete(sender: UIBarButtonItem) {
        self.textField.resignFirstResponder()
    }
    
    internal func dropdownButtonDidTap(sender: UIButton) {
        self.textField.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return !self.showsDropdownButton
    }

}
