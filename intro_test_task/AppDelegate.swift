//
//  AppDelegate.swift
//  intro_test_task
//
//  Created by Vitalii Shvetsov on 13.05.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: OverviewViewController())
    window?.makeKeyAndVisible()
    return true
  }
}

