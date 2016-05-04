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

    private func prepareAppearances() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        let navBarAttributes = [
            NSFontAttributeName: UIFont.regularFontOfSize(16.0),
            NSForegroundColorAttributeName: UIColor.themeForegroundColor()
        ]
        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
        UINavigationBar.appearance().barTintColor = UIColor.themeBackgroundColor()
        UINavigationBar.appearance().tintColor = UIColor.themeForegroundColor()
        UINavigationBar.appearance().translucent = false
        
        UIToolbar.appearance().translucent = false
        UIToolbar.appearance().barTintColor = UIColor.themeBackgroundColor()
        
        let barButtonAttributes = [
            NSFontAttributeName: UIFont.regularFontOfSize(12.0)
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributes, forState: .Normal)
        UIBarButtonItem.appearance().tintColor = UIColor.barButtonItemColor()
        
        UIPageControl.appearance().backgroundColor = UIColor.pageControlBackgroundColor()
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor.tabBarBackgroundColor()
        UITabBar.appearance().tintColor = UIColor.themeBackgroundColor()
        
        let tabBarAttributes = [
            NSFontAttributeName: UIFont.regularFontOfSize(9.0)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(tabBarAttributes, forState: .Normal)
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.prepareAppearances()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = NTTabBarController()
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

