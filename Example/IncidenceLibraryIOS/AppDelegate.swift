//
//  AppDelegate.swift
//  ios-base
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap Inc. All rights reserved.
//

import UIKit
import IncidenceLibraryIOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = {
    guard let appD = UIApplication.shared.delegate as? AppDelegate else {
      return AppDelegate()
    }
    return appD
  }()

  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let apiKey = "b3JnLmNvY29hcG9kcy5kZW1vLkluY2lkZW5jZUxpYnJhcnlJT1MtRXhhbXBsZTpkOTBlMTA3ZjdhNGU1NmQyYzlkMTJhMHM3ZTQ1ZDAwMA=="
      let config = IncidenceLibraryConfig(apiKey: .init(apiKey), env: .PRE)
      IncidenceLibraryManager.setup(config, completion: { result in
          print(result)
          if (result.status) {
              print("SETUP OK")
          } else {
              print("SETUP KO")
          }
     })
      
      let firstViewController = DevelopmentViewController.create()
      let rootVC = UINavigationController(rootViewController: firstViewController)
      rootVC.isNavigationBarHidden = false
      
      window?.rootViewController = rootVC
      /*
      UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
      UINavigationBar.appearance().shadowImage = UIImage()
      UINavigationBar.appearance().tintColor = UIColor.yellow
      UINavigationBar.appearance().barTintColor = UIColor.red
      UINavigationBar.appearance().isTranslucent = false
      UINavigationBar.appearance().clipsToBounds = false
      UINavigationBar.appearance().backgroundColor = UIColor.blue
      //UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font : (UIFont(name: "FONT NAME", size: 18))!, NSAttributedStringKey.foregroundColor: UIColor.white]
      */
      return true
  }
}
