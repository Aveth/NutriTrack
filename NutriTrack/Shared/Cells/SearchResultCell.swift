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
           return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    internal var subtitle: String? {
        get {
            return self.subtitleLabel.text
        }
        set {
            self.subtitleLabel.text = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    lazy private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFontOfSize(10.0)
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont()
        label.textColor = UIColor.defaultTextColor()
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
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.setNeedsUpdateConstraints()
    }
    
    override internal func prepareForReuse() {
        super.prepareForReuse()
        self.title = nil
        self.subtitle = nil
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.titleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
        
        self.subtitleLabel.autoPinEdgesToSuperviewMarginsExcludingEdge(.Top)
        self.subtitleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel)
    }

}
