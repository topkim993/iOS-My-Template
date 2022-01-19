//
//  AppDelegate.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import UIKit
import AlamofireNetworkActivityLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return false }
        window.rootViewController = BeginNavigationController()
        window.makeKeyAndVisible()

        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
        return true
    }

}

