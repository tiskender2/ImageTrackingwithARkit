//
//  AppDelegate.swift
//  ARKitExample
//
//  Created by Tolga İskender on 15.07.2020.
//  Copyright © 2020 Tolga İskender. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpMainVC()
        return true
    }

    fileprivate func setUpMainVC(){
        let mainVC = MainVC.init(nibName: "MainVC", bundle: nil)
        let navVC = UINavigationController(rootViewController: mainVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

}

