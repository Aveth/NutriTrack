//
//  SearchResultCell.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-16.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    static internal let reuseIdentifier: String = "SearchResultCell_ReuseIdentifier"
    
    internal var title: String? {
        get {
           return self.textLabel?.text
        }
        set {
            self.textLabel?.text = newValue
        }
    }
    
    internal var subtitle: String? {
        get {
            return self.subtitleLabel.text
        }
        set {
            self.subtitleLabel.text = newValue
        }
    }
    
    lazy private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFontOfSize(10.0)
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
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
        self.contentView.addSubview(self.subtitleLabel)
        self.setNeedsUpdateConstraints()
    }
    
    

}
