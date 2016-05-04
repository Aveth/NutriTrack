//
//  ATBubbleViewCell.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-02.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class ATBubbleViewCell: UICollectionViewCell {
    
    static internal let reuseIdentifier: String = "ATBubbleViewCell_ReuseIdentifier"
    
    internal var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    internal var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
            self.setNeedsUpdateConstraints()
        }
    }
    
    override internal var backgroundColor: UIColor? {
        get {
            return self.contentView.backgroundColor
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
    
    lazy private var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFontOfSize(9.0)
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
        label.textColor = UIColor.themeForegroundColor()
        return label
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        
        self.imageView.autoPinEdgeToSuperviewEdge(.Top, withInset: 5.0)
        self.imageView.autoSetDimensionsToSize(CGSize(width: self.frame.width / 2.0, height: self.frame.height / 2.0))
        self.imageView.autoAlignAxisToSuperviewAxis(.Vertical)
        
        self.titleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.imageView, withOffset: 3.0)
        self.titleLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 2.0)
        self.titleLabel.autoPinEdgeToSuperviewEdge(.Left)
        self.titleLabel.autoPinEdgeToSuperviewEdge(.Right)
        
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.frame.height / 2.0
    }
    
}
