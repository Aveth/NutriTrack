//
//  NTEmptyViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class NTEmptyViewController: UIViewController {
    
    lazy private var emptyView: NTEmptyView = NTEmptyView()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.emptyView)
        
        self.updateViewConstraints()
    }
    
    override internal func updateViewConstraints() {
        super.updateViewConstraints()
        self.emptyView.autoPinEdgesToSuperviewEdges()
    }

}
