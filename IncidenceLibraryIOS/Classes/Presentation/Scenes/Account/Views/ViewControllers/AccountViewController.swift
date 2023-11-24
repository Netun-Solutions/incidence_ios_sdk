//
//  AccountViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import UIKit

public class AccountViewController: IABaseViewController, StoryboardInstantiable {
    
    let NOTIFICATIONS_SWITCH_ID = 1
    
    public static var storyboardFileName = "AccountScene"
    private var viewModel: AccountViewModel! { get { return baseViewModel as? AccountViewModel }}
    
    @IBOutlet weak var myDataMenuView: MenuView!
    @IBOutlet weak var activeSessionsMenuView: MenuView!
    
    @IBOutlet weak var notificationsMenuView: MenuView!
    @IBOutlet weak var closeSessionMenuView: MenuView!
    @IBOutlet weak var deleteAccountMenuView: MenuView!
    @IBOutlet weak var helpMenuView: MenuView!
    
    var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    public static func create(with viewModel: AccountViewModel) -> AccountViewController {
        let view = AccountViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        notificationsMenuView.configure(text: "notifications".localized(), iconImage: UIImage.app( "Bell"), switchDelegate: self)
/*
        notificationsMenuView.configure(text: "Notificaciones", iconImage: UIImage.app( "Bell"))
        notificationsMenuView.onTap { [weak self] in
            let vm = AccountNotificationViewModel()
            let vc = AccountNotificationViewController.create(with: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        */
        activeSessionsMenuView.configure(text: "active_sessions".localized(), iconImage: UIImage.app( "Mobile"))
        activeSessionsMenuView.onTap { [weak self] in
            let vm = AccountActiveSessionsViewModel()
            let vc = AccountActiveSessionsViewController.create(with: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        myDataMenuView.configure(text: "my_data".localized(), iconImage: UIImage.app( "User"))
        myDataMenuView.onTap { [weak self] in
            let vm = AccountMyDataViewModel()
            let vc = AccountMyDataViewController.create(with: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        /*
        helpMenuView.configure(text: "help".localized(), iconImage: UIImage.app( "Help"))
        helpMenuView.onTap { [weak self] in
            let vm = AccountHelpViewModel()
            let vc = AccountHelpViewController.create(with: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }*/
        helpMenuView.isHidden = true
        
        closeSessionMenuView.configure(text: "sign_out".localized())
        closeSessionMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configureBottomSheet(type: .closeSession)
            strongSelf.present(strongSelf.bottomSheetController!, animated: true, completion: nil)
        }
        
        deleteAccountMenuView.configure(text: "delete_account".localized(), color: .red)
        deleteAccountMenuView.onTap { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.configureBottomSheet(type: .deleteAccount)
            strongSelf.present(strongSelf.bottomSheetController!, animated: true, completion: nil)
        }
    }
    
    override func loadData() {
        
        let nd = Core.shared.getDeviceNotification(notificationId: NOTIFICATIONS_SWITCH_ID)
        let checked = (nd != nil && nd?.status == 0) ? false : true
        notificationsMenuView.setSwitchValue(checked)
    }
    
    private func configureBottomSheet(type: AccountButtonsSheet) {
        let view = ButtonsBottomSheetView()
        switch type {
        case .deleteAccount:
            view.configure(delegate: self, title:nil, desc: "delete_account_message".localized(), firstButtonText: "cancel".localized(), secondButtonText: "delete".localized(), identifier: AccountButtonsSheet.deleteAccount)
        case .closeSession:
            view.configure(delegate: self, title:nil, desc: "sign_out_message".localized(), firstButtonText: "cancel".localized(), secondButtonText: "sign_out".localized(), identifier: AccountButtonsSheet.closeSession)
        case .notifications:
            view.configure(delegate: self, title:nil, desc: "notifications_disable_message".localized(), firstButtonText: "cancel".localized(), secondButtonText: "accept".localized(), identifier: AccountButtonsSheet.notifications)
        }
        
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
    }
}

extension AccountViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
        
        guard let type = identifier as? AccountButtonsSheet else { return }
        switch type {
        case .closeSession:
            bottomSheetController?.dismiss(animated: true, completion: nil)
        case .deleteAccount:
            break
        case .notifications:
            notificationsMenuView.setSwitchValue(true)
        }
    }
    
    func secondButtonPressed(identifier: Any?) {
        guard let type = identifier as? AccountButtonsSheet else { return }
        switch type {
        case .closeSession:
            bottomSheetController?.dismiss(animated: true, completion: {
                Core.shared.signOut()
            })
        case .deleteAccount:
            bottomSheetController?.dismiss(animated: true, completion: {
                
                self.showHUD()
                Api.shared.deleteAccount(completion: { result in
                    if (result.isSuccess())
                    {
                        Core.shared.signOut()
                    }
                    else
                    {
                        self.hideHUD()
                        self.onBadResponse(result: result)
                    }
               })
            })
        case .notifications:
            bottomSheetController?.dismiss(animated: true, completion: nil)
            
            self.showHUD()
            Api.shared.setDeviceNotifications(notificationId: NOTIFICATIONS_SWITCH_ID, status: 0, completion: { result in
                self.hideHUD()
                if (!result.isSuccess())
                {
                    self.notificationsMenuView.setSwitchValue(true)
                }
           })
        }
    }
}

extension AccountViewController: MenuViewSwitchDelegate {
    func menuView(with identifier: Any?, switchValue value: Bool) {
        if value == false {
            configureBottomSheet(type: .notifications)
            present(bottomSheetController!, animated: true, completion: nil)
        }
        else {
            self.showHUD()
            Api.shared.setDeviceNotifications(notificationId: NOTIFICATIONS_SWITCH_ID, status: 1, completion: { result in
                self.hideHUD()
                if (!result.isSuccess())
                {
                    self.notificationsMenuView.setSwitchValue(false)
                }
           })
        }
    }
}
