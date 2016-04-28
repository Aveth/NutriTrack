//
//  NTDropdownField.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-27.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTPickerField: UIView, UITextFieldDelegate {

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
    
    override internal var inputView: UIView? {
        get {
            return self.textField.inputView
        }
        set {
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
        field.layer.cornerRadius = 5.0
        field.leftViewMode = .Always
        field.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        field.rightViewMode = .Always
        field.rightView = self.dropdownButton
        field.delegate = self
        field.inputAccessoryView = self.pickerToolbar
        field.font = UIFont.defaultFont()
        return field
    }()
    
    lazy private var dropdownButton: UIButton = {
        let image = UIImage(named: "dropdown_arrow")
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0))
        button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: "dropdownButtonDidTap:", forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy private var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .Done, target: self, action: "pickerToolbarDidComplete:")
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
        
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.titleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Right)
        self.titleLabel.autoSetDimension(.Width, toSize: 90.0)
        
        self.textField.autoPinEdgeToSuperviewMargin(.Right)
        self.textField.autoPinEdgeToSuperviewEdge(.Top, withInset: 20.0)
        self.textField.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20.0)
        self.textField.autoPinEdge(.Left, toEdge: .Right, ofView: self.titleLabel)
        
        self.pickerToolbar.autoSetDimension(.Height, toSize: 35.0)
        
    }
    
    internal func pickerToolbarDidComplete(sender: UIBarButtonItem) {
        self.textField.resignFirstResponder()
    }
    
    internal func dropdownButtonDidTap(sender: UIButton) {
        self.textField.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }

}
