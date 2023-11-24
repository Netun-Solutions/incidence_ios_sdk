//
//  AppNavigation.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

enum NavigationStyle {
    case regular
    case transparent
    case white
}

final class AppNavigation {
    static func setupNavigationApperance(_ navigationController: UINavigationController, with style: NavigationStyle) {
        switch style {
        case .regular:
            navigationController.navigationItem.backBarButtonItem?.title = ""
            if #available(iOS 14.0, *) {
                navigationController.navigationItem.backButtonDisplayMode = .minimal
            }
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = UIColor.app(.incidence100)
            navigationController.navigationBar.shadowImage = UIImage()
         
            navigationController.navigationBar.backIndicatorImage = nil
            navigationController.navigationBar.backIndicatorTransitionMaskImage = nil
            
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.app(.incidence100)
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                //appearance.titleTextAttributes = attributes
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.compactAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }
            
        case .white:
            navigationController.navigationItem.backBarButtonItem?.title = ""
            if #available(iOS 14.0, *) {
                navigationController.navigationItem.backButtonDisplayMode = .minimal
            }
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.barTintColor = UIColor.app(.white)
            navigationController.navigationBar.shadowImage = UIImage()
         
            navigationController.navigationBar.backIndicatorImage = nil
            navigationController.navigationBar.backIndicatorTransitionMaskImage = nil
            
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.app(.white)
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                //appearance.titleTextAttributes = attributes
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.compactAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }
            
        case .transparent:
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            
            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundImage = UIImage()
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                
                //appearance.titleTextAttributes = attributes
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.compactAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }
        }
    }
}

