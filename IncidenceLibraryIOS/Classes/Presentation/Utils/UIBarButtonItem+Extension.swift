//
//  UIBarButtonItem+Extension.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 20/6/22.
//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage.app( imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 34).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 34).isActive = true

        return menuBarItem
    }
}
