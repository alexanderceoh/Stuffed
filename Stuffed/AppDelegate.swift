//
//  AppDelegate.swift
//  Stuffed
//
//  Created by alex oh on 10/27/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
            
        case .Pad :
            // use the gameboard
            let storyboard = UIStoryboard(name: "GameBoard", bundle: nil)
            window?.rootViewController = storyboard.instantiateInitialViewController()
        case .Phone:
            // use the gamepad
            let storyboard = UIStoryboard(name: "GamePad", bundle: nil)
            window?.rootViewController = storyboard.instantiateInitialViewController()
        case .TV:
            print("To be added")
        case .Unspecified:
            print("You're going to crash bro")
            
        }
                
        window?.makeKeyAndVisible()
        
        return true
    }

}

