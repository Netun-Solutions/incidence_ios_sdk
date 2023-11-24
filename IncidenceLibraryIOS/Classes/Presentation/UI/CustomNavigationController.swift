//
//  CustomNavigationController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        navigationItem.titleView?.widthAnchor.constraint(equalTo: navigationBar.widthAnchor, constant: -40).isActive = true
        if let navigationBar = navigationController?.navigationBar {
                    NSLayoutConstraint.activate([
                        navigationItem.titleView!.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16),
                        navigationItem.titleView!.heightAnchor.constraint(equalToConstant: 36)
                    ])
                }
    }
}
