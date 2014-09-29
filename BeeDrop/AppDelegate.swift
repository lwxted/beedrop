//
//  AppDelegate.swift
//  BeeDrop
//
//  Created by Ted Li on 9/26/14.
//  Copyright (c) 2014 Ted Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Jiaji test driver-side alert window
      //  dispatch_async(dispatch_queue_create("poll", nil), {
//            var alertWindow = AlertWindow()
//            var info = alertWindow.driverAcceptDataHelper()
//            alertWindow.showDriverAccept(info)
      //  })
        
        //Hongyi tryout here
                
        let jsonObject: [String: AnyObject] = ["bUser": true, "ID": 21, "name": "Bob", "curLoc": [0.3, 0.0] ]
        let driverObject: [String: AnyObject] = ["bUser": false, "ID": 52, "name": "Kim kardashian", "curLoc": [0.3, 0.0] ]
        let driverObject1: [String: AnyObject] = ["bUser": false, "ID": 53, "name": "Lamar Odom", "curLoc": [0.30001, 0.0] ]
        
        let jsonObject1: [String: AnyObject] = ["ID": 21, "fromLoc": [0.3, 0.0], "toLoc": [0.3, 0.0], "requestProduct": "shit", "payment": 0.1, "passcode":"fuckkkkkk"]
        let jsonObject2: [String: AnyObject] = ["ID": 21]
        let jsonObject3: [String: AnyObject] = ["userID": 21, "driverID": 53]
        let jsonObject4: [String: AnyObject] = ["driverID": 53]
        let jsonObject5: [String: AnyObject] = ["userID": 21]
        let jsonObject6: [String: AnyObject] = ["userID": 21]
        
        var handeler = RequestHandler()
        
        var returnedJson :[String: AnyObject] = ["status": -1]
        
        //User
//        handeler.sendRequestByURL(jsonObject, tag: "addPerson")
//        handeler.sendRequestByURL(driverObject, tag: "addPerson")
//        handeler.sendRequestByURL(jsonObject1, tag: "submitUserDeliveryForm")
//        handeler.sendRequestByURL(jsonObject2, tag: "listNearbyDrivers")
//        handeler.sendRequestByURL(jsonObject3, tag: "selectDriver")
//        
//        while ( (returnedJson["status"] as AnyObject? as? Int) == -1) {
//            returnedJson = handeler.sendRequestByURL(jsonObject5, tag: "pollDriverAck")!
//            sleep(2)
//        }
        
        //Driver
//        handeler.sendRequestByURL(driverObject1, tag: "addPerson")
//
//        returnedJson = ["status": -1]
//        while ((returnedJson["status"] as AnyObject? as? Int) == -1) {
//            returnedJson = handeler.sendRequestByURL(jsonObject4, tag: "pollUserRequest")!
//            sleep(2)
//        }
//        
//        handeler.sendRequestByURL(jsonObject6, tag: "driverAcceptRequest")
        
//        println("Printing Json object")
//        println(returnedJson)
        
        
        //=================================================================================//
        
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

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }

}

