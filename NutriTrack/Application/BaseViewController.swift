//
//  BaseViewController.swift
//  NutriTrack
//
//  Created by Avais on 2016-05-03.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var _isModal: Bool = false
    
    internal var navigationTitle: String? {
        get {
            return self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
        }
    }
    
    internal var rightBarButtonTitle: String? {
        get {
            return self.navigationItem.rightBarButtonItem?.title
        }
        set {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: newValue, style: .Plain, target: self, action: #selector(rightBarButtonDidTap(_:)))
        }
    }
    
    internal var rightBarButtonImage: UIImage? {
        get {
            return self.navigationItem.rightBarButtonItem?.image
        }
        set {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: newValue, style: .Plain, target: self, action: #selector(rightBarButtonDidTap(_:)))
        }
    }
    
    internal var leftBarButtonTitle: String? {
        get {
            return self.navigationItem.leftBarButtonItem?.title
        }
        set {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: newValue, style: .Plain, target: self, action: #selector(leftBarButtonDidTap(_:)))
        }
    }
    
    internal var leftBarButtonImage: UIImage? {
        get {
            return self.navigationItem.leftBarButtonItem?.image
        }
        set {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: newValue, style: .Plain, target: self, action: #selector(leftBarButtonDidTap(_:)))
        }
    }
    
    internal var isModal: Bool {
        get {
            return self._isModal
        }
        set {
            self._isModal = newValue
            self.leftBarButtonImage = UIImage(named: "close")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.backgroundColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    internal func rightBarButtonDidTap(sender: UIBarButtonItem) {}
    internal func leftBarButtonDidTap(sender: UIBarButtonItem) {
        if self.isModal {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}
