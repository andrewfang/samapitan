//
//  AppDelegate.swift
//  samapitan
//
//  Created by Andrew Fang on 5/10/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import UIKit
import  Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Override point for customization after application launch.
        
        FIRApp.configure()
    }

}

