//
//  AppDelegate.swift
//  UniChef
//
//  Created by Andrew/Leena on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navbar = UINavigationBar.appearance()
        navbar.barTintColor = UIColor(red: 14.0/255, green: 134.0/255, blue: 171.0/255, alpha: 1)
        //
        let tabbar = UITabBar.appearance()
        //      tabbar.barTintColor = UIColor(red: 14.0/255, green: 134.0/255, blue: 171.0/255, alpha: 1)
        tabbar.tintColor = UIColor.whiteColor()
        Parse.setApplicationId("BrD0JFbqvvFnpCkC2THrrzF6moXHf0CAYSZaeGO4",clientKey: "IE9UjUtCoUE2gm9jLkvZSIJfOwgx8l5TLGMW6Dug")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFUser.enableAutomaticUser()
        getRandomName()
        
        return true
    }
    
    func getRandomName(){
        if PFUser.currentUser()?["name"] == nil{
            let path = NSBundle.mainBundle().pathForResource("Names", ofType:"plist")
            let names = NSArray(contentsOfFile: path!)
            let randomIndex = Int(arc4random_uniform(UInt32(names!.count)))
            if let randomName = names?[randomIndex] as? String {
                PFUser.currentUser()?["name"] = randomName
                PFUser.currentUser()?.saveInBackground()
            }
        }
       
        
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

