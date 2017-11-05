//
//  AppDelegate.swift
//  NewBuckitApp
//
//  Created by Zhongwu Shi on 08/10/2017.
//  Copyright © 2017 Zhongwu Shi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
   
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController")
        window?.rootViewController = mainNavigationController
        /*if (FBSDKAccessToken.current() != nil) {
            print("token: " + "\(AccessToken.current)")
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name, picture.type(large)"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    // Process error
                    print("fail")
                    print("Error: \(error)")
                }
                else
                {
                    let json = JSON(result)
                    let defaults = UserDefaults.standard
                    defaults.set(json["first_name"].string, forKey: "first_name")
                    defaults.set(json["last_name"].string, forKey: "last_name")
                    defaults.set(json["picture"]["data"]["url"].string, forKey: "avatarURL")
                }
            })
            
            
            let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "mainNavigationController")
            window?.rootViewController = mainNavigationController
            print("logged in")
            //if you are logged
        } else {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            window?.rootViewController = loginViewController
            print("not logged in")
            //if you are not logged
        }*/
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

