//
//  NTFoodDetailsViewCell.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-22.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTFoodDetailsViewCell: UITableViewCell {
    
    private var _value: Float?
    
    internal var name: String? {
        get {
            return self.textLabel?.text
        }
        set {
            self.textLabel?.text = newValue
        }
    }
    
    internal var value: Float? {
        get {
            return _value
        }
        set {
            _value = newValue
            if let val = newValue {
                self.valueLabel.text = String(format: "%.2f", val)
            }
        }
    }

    internal var unit: String? {
        get {
            return self.unitLabel.text
        }
        set {
            self.unitLabel.text = newValue
        }
    }
    
    private var unitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont()
        return label
    }()
    lazy private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont()
        return label
    }()
    
    override internal init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.defaultFont()
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.contentView.addSubview(self.valueLabel)
        self.contentView.addSubview(self.unitLabel)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.unitLabel.autoPinEdgeToSuperviewMargin(.Right)
        self.unitLabel.autoPinEdgeToSuperviewMargin(.Top)
        self.unitLabel.autoPinEdgeToSuperviewMargin(.Bottom)
        
        self.valueLabel.autoPinEdge(.Right, toEdge: .Left, ofView: self.unitLabel, withOffset: -5.0)
        self.valueLabel.autoPinEdgeToSuperviewMargin(.Top)
        self.valueLabel.autoPinEdgeToSuperviewMargin(.Bottom)
        
    }
    
    

}
