//
//  AppDelegate.swift
//  Marvel
//
//  Created by Aitor Sola on 24/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let characterListVC = CharactersListViewController.build()
    window?.rootViewController = UINavigationController(rootViewController: characterListVC)
    window?.makeKeyAndVisible()
    return true
  }

}

