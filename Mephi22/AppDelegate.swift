//
//  AppDelegate.swift
//  Mephi22
//
//  Created by Mikhail Rudanov on 08/12/2017.
//  Copyright © 2017 Mikhail Rudanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootAssembly: RootAssembly = RootAssembly()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainNavigationController = rootAssembly.mainNavigationController
        let mainViewController = rootAssembly.menuAssembly.menuViewController()
        mainNavigationController.viewControllers[0] = mainViewController
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

