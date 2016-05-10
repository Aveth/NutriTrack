//
//  NTActionCell.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-10.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTActionCell: UITableViewCell {
    
    internal enum Type: Int {
        case View
        case Delete
        func image() -> UIImage? {
            switch self {
                case View: return UIImage(named: "view")
                case Delete: return UIImage(named: "delete")
            }
        }
    }
    
    static internal let reuseIdentifier: String = "NTActionCell_ReuseIdentifier"
    
    private var _type = Type.View
    
    internal var title: String? {
        get {
            return self.textLabel?.text
        }
        set {
            self.textLabel?.text = newValue
        }
    }
    
    internal var type: Type {
        get {
            return self._type
        }
        set {
            self._type = newValue
            self.imageView?.image = newValue.image()
        }
    }
    
    override internal init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class doesn't support NSCoding.")
    }
    
    private func buildView() {
        self.textLabel?.font = UIFont.defaultFont()
        self.textLabel?.textColor = UIColor.defaultTextColor()
        self.setNeedsUpdateConstraints()
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.imageView?.autoSetDimensionsToSize(CGSize(width: 20.0, height: 20.0))
        self.imageView?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.imageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 15.0)
        
        self.textLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: self.imageView!, withOffset: 5.0)
        self.imageView?.autoPinEdgeToSuperviewMargin(.Top)
        self.imageView?.autoPinEdgeToSuperviewMargin(.Bottom)
     
    }
    
}

