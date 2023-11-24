//
//  SceneDelegate.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 20/10/21.
//

import UIKit
import CarPlay


class SceneDelegate: UIResponder, UISceneDelegate
{
    public var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            Core.shared.window = window
            Core.shared.showContent()
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene)
    {
        self.onAppBecomeActive()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        self.onAppResignActive()
    }
    
    func onAppBecomeActive()
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        Core.shared.onAppBecomeActive()
    }
    
    func onAppResignActive()
    {
        Core.shared.onAppResignActive()
    }
}
