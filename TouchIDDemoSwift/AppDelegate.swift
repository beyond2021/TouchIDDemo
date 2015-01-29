//
//  AppDelegate.swift
//  TouchIDDemoSwift
//
//  Created by KEEVIN MITCHELL on 1/26/15.
//  Copyright (c) 2015 Beyond 2021. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
   
    
    // MARK: - Saving to the documents Directory
    
    //Because we need to do almost the same thing in two different classes, we’ll implement the two methods in the AppDelegate class and then by instantiating an application delegate object, we’ll access them directly. The first method is going to return the full path of the notes file.
    
    
    //I named the note file “notesData”, but it actually doesn’t matter how you’ll name it. In the above implementation, it’s demonstrated how we can access the documents directory in Swift. That’s useful, and you can keep it as a small reusable piece of code for future use in your applications. Besides that, this is the first time that we write a method that returns a value, and in this case as string value. When this method will be called, the full path to the notes data file will be returned, so we won’t have to manually compose it again.
    
    func getPathOfDataFile() -> String {
        let pathsArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsPath = pathsArray[0] as String
        let dataFilePath = documentsPath.stringByAppendingPathComponent("notesData")
        
        return dataFilePath
    }
    
    // Below checks if the file actually exists or not to the documents directory.  Here we use the NSFileManager class to determine whether the file exists or not, and it works just like it does in Objective-C. If the file is found, then we return true, otherwise the false value is returned.    
    
    func checkIfDataFileExists() -> Bool {
        if NSFileManager.defaultManager().fileExistsAtPath(getPathOfDataFile()) {
            return true
        }
        
        return false
    }
    
    

}

