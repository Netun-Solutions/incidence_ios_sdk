//
//  AccountNotificationViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/6/21.
//

import UIKit

class AccountNotificationViewController: IABaseViewController, StoryboardInstantiable {
    
    static var storyboardFileName = "AccountScene"
    private var viewModel: AccountNotificationViewModel! { get { return baseViewModel as? AccountNotificationViewModel }}
    
    @IBOutlet weak var vehicleMenuView: MenuView!
    @IBOutlet weak var promotionsMenuView: MenuView!
    @IBOutlet weak var disclaimerLabel: TextLabel!
    
    
    // MARK: - Lifecycle
    static func create(with viewModel: AccountNotificationViewModel) -> AccountNotificationViewController {
        let view = AccountNotificationViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }

    override func setUpUI() {
        super.setUpUI()
        vehicleMenuView.configure(text: viewModel.vehicleText, switchDelegate: self)
        promotionsMenuView.configure(text: viewModel.promotionsText, switchDelegate: self)
        
        disclaimerLabel.text = viewModel.disclaimerText
    }
}

extension AccountNotificationViewController: MenuViewSwitchDelegate {
    func menuView(with identifier: Any?, switchValue value: Bool) {
       
    }
}
