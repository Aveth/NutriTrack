//
//  LoadingIndicator.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-04.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {

    lazy private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        return view
    }()
    
    lazy private var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.spinner)
        self.deactivte()
        self.setNeedsUpdateConstraints()
    }
    
    internal func activate() {
        self.spinner.startAnimating()
        self.hidden = false
    }
    
    internal func deactivte() {
        self.spinner.stopAnimating()
        self.hidden = true
    }
    
    override internal func updateConstraints() {
        super.updateConstraints()
        self.spinner.autoCenterInSuperview()
        self.backgroundView.autoPinEdgesToSuperviewEdges()
    }
    

}
