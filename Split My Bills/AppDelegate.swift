//
//  AppDelegate.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  var navigationController = UINavigationController()
  
  var rootVC = BillSetupViewController()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    navigationController.viewControllers = [rootVC]
    
    window!.rootViewController = navigationController
    window!.makeKeyAndVisible()
    return true
  }
}

