//
//  AppDelegate.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let vc = MainViewController(nibName: MainViewController.className, bundle: nil)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }
}

