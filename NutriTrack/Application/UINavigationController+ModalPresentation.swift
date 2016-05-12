//
//  UIViewController+Navigation.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-26.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    internal func presentViewController(controller: UIViewController, animated: Bool) {
        let navigation = UINavigationController(rootViewController: controller)
        self.presentViewController(navigation, animated: animated, completion: nil)
    }
    
    internal func presentViewController(controller: UIViewController) {
        self.presentViewController(controller, animated: true)
    }
    
}
