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
      IncidenceLibraryManager.setup(config)
      
      let firstViewController = DevelopmentViewController.create()
      let rootVC = UINavigationController(rootViewController: firstViewController)
      rootVC.isNavigationBarHidden = false
      
      window?.rootViewController = rootVC

      return true
  }
}
