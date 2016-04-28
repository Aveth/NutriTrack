//
//  AppDelegate.swift
//  NutriTrack
//
//  Created by Avais on 2016-04-18.
//  Copyright © 2016 Aveth. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?
    internal var navigationController: UINavigationController?

    private func prepareAppearances() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        let navBarAttributes = [
            NSFontAttributeName: UIFont.boldFontOfSize(20.0)
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarColor()
        
        let barButtonAttributes = [
            NSFontAttributeName: UIFont.regularFontOfSize(14.0)
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        UIBarButtonItem.appearance().tintColor = UIColor.barButtonItemColor()
        
        UIPageControl.appearance().backgroundColor = UIColor.pageControlBackgroundColor()
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.prepareAppearances()
        
        self.navigationController = UINavigationController(rootViewController: NTMealsViewController())
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = self.navigationController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

