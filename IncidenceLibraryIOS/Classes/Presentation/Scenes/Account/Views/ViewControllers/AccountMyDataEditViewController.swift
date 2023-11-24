//
//  AccountMyDataEditViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit

class AccountMyDataEditViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextFieldView: TextFieldView!
    @IBOutlet weak var mobileTextFieldView: TextFieldView!
    @IBOutlet weak var IDTextFieldView: TextFieldWithSelectView!
    @IBOutlet weak var datebirthTextFieldView: TextFieldView!
    @IBOutlet weak var emailTextFieldView: TextFieldView!
    @IBOutlet weak var appVersionTextFieldView: TextFieldView!
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "AccountScene"
    private var viewModel: AccountMyDataEditViewModel! { get { return baseViewModel as? AccountMyDataEditViewModel }}
    
    private var hasChanges = false
    private var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    static func create(with viewModel: AccountMyDataEditViewModel) -> AccountMyDataEditViewController {
        let view = AccountMyDataEditViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        setUpHideKeyboardOnTap()
        setUpKeyboardObservers()
        setUpNavigation()
        
        continueButton.setTitle(viewModel.saveButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)

        nameTextFieldView.showEditable = true
        nameTextFieldView.showSuccess = false
        nameTextFieldView.placeholder = viewModel.fieldNameTitle
        nameTextFieldView.title = viewModel.fieldNameTitle
        nameTextFieldView.delegate = self
        
        mobileTextFieldView.isEnabled = false
        mobileTextFieldView.showEditable = false
        mobileTextFieldView.showSuccess = false
        mobileTextFieldView.placeholder = viewModel.fieldPhoneTitle
        mobileTextFieldView.title = viewModel.fieldPhoneTitle
        
        emailTextFieldView.showEditable = true
        emailTextFieldView.showSuccess = false
        emailTextFieldView.placeholder = viewModel.fieldEmailTitle
        emailTextFieldView.title = viewModel.fieldEmailTitle
        emailTextFieldView.delegate = self
        
        IDTextFieldView.showEditable = true
        IDTextFieldView.showSuccess = false
        IDTextFieldView.placeholder = viewModel.fieldIDTitle
        IDTextFieldView.title = viewModel.fieldIDTitle
        IDTextFieldView.configure(options: ["nif".localized(), "nie".localized(), "cif".localized()])
        IDTextFieldView.delegate = self
        
        datebirthTextFieldView.showEditable = true
        datebirthTextFieldView.showSuccess = false
        datebirthTextFieldView.setUpDatePicker()
        datebirthTextFieldView.placeholder = viewModel.fieldDatebirthTitle
        datebirthTextFieldView.title = viewModel.fieldDatebirthTitle
        
        appVersionTextFieldView.isEnabled = false
        appVersionTextFieldView.showEditable = false
        appVersionTextFieldView.showSuccess = false
        appVersionTextFieldView.title = "version_app".localized()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersionNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        appVersionTextFieldView.value = String.init(format: "%@ (%@)", appVersion ?? "", appVersionNumber ?? "")
    }
    
    override func loadData() {
        let user = Core.shared.getUser()
        
        nameTextFieldView.value = (user?.name ?? "")
        mobileTextFieldView.value = (user?.phone ?? "")
        if let phone = user?.phone {
            let formatted = phone.separate(every:3, with: " ")
            mobileTextFieldView.value = formatted
        }
        
        emailTextFieldView.value = (user?.email ?? "")
        IDTextFieldView.value = (user?.dni ?? "")
        datebirthTextFieldView.value = (DateUtils.dateStringInternationalToSpanish(user?.birthday))
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage.app( "Close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closePressed))
        closeButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closePressed() {
        if (hasChanges && continueButton.isEnabled) {
            showSavePopUp(cleanAll: true)
        }
        else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if (hasChanges && continueButton.isEnabled) {
            showSavePopUp(cleanAll: false)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func backPressed(){
        if (hasChanges && continueButton.isEnabled) {
            showSavePopUp(cleanAll: false)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        save(cleanAll: false)
    }
    private func save(cleanAll: Bool) {
        
        let name = nameTextFieldView.value
        let phone = mobileTextFieldView.value?.replacingOccurrences(of: " ", with: "")
        let email = emailTextFieldView.value
        var identityType:String? = IDTextFieldView.valueOption
        if (identityType == "cif".localized()) {
            identityType = "3"
        } else if (identityType == "nie".localized()) {
            identityType = "2"
        } else {
            identityType = "1"
        }
        
        let dni = IDTextFieldView.value
        
        var birthday = ""
        let cumple = datebirthTextFieldView.value
        if (cumple?.count ?? 0 > 1) {
            birthday = DateUtils.dateStringSpanishToInternational(cumple)
        }
        
        if let nam = name, nam.count > 0
        {
            if let ema = email, ema.count > 0
            {
                if let d = dni, d.count > 0
                {
                    showHUD()
                    Api.shared.updateUser(name: name, phone: phone, identityType: identityType, dni: dni, email: email, birthday: birthday, completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            self.hasChanges = false
                            
                            let count = self.navigationController?.viewControllers.count
                            if count! > 1 {
                                if let baseVC = self.navigationController?.viewControllers[count! - 2] as? IABaseViewController {
                                    baseVC.reloadData()
                                }
                            }
                            
                            EventNotification.post(code: .USER_UPDATED)
                            
                            if (cleanAll)
                            {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            else
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                   })
                }
                else
                {
                    showAlert(message: "alert_inform_dni".localized())
                }
            }
            else
            {
                showAlert(message: "alert_inform_email".localized())
            }
        }
        else
        {
            showAlert(message: "alert_inform_name".localized())
        }
    }
    
    func showSavePopUp(cleanAll: Bool)
    {
        let identifier = cleanAll ? "changesCleanAll" : "changes"
        let view = ButtonsBottomSheetView(false)
        view.configure(delegate: self, title: "wish_continue".localized(), desc: "no_saved_changes".localized(), firstButtonText: "save_and_close".localized(), secondButtonText: "no_save".localized(), identifier: identifier)
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
        present(bottomSheetController!, animated: true, completion: nil)
    }
}

extension AccountMyDataEditViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        var text1 = nameTextFieldView.value
        var text2 = emailTextFieldView.value
        let text3 = IDTextFieldView.value
        
        if let text = view.value,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if (view == nameTextFieldView) {
                text1 = updatedText
            }
            else if (view == emailTextFieldView) {
                text2 = updatedText
            }
        }
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0  && text3?.count ?? 0 > 0
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = nameTextFieldView.value
        let text2 = emailTextFieldView.value
        let text3 = IDTextFieldView.value
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0  && text3?.count ?? 0 > 0
    }
}

extension AccountMyDataEditViewController: TextFieldWithSelectViewDelegate {
    func textFieldView(view: TextFieldWithSelectView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        let text1 = nameTextFieldView.value
        let text2 = emailTextFieldView.value
        var text3 = IDTextFieldView.value
        
        if let text = textfield.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //nameTextFieldView.showSuccess = updatedText.count == 3
            
            text3 = updatedText
        }
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0 && text3?.count ?? 0 > 0
        
        return true
    }
    func dropTextFieldShouldClear(_ textField: UITextField) {
        let text1 = nameTextFieldView.value
        let text2 = emailTextFieldView.value
        let text3 = IDTextFieldView.value
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0  && text3?.count ?? 0 > 0
    }
}

extension AccountMyDataEditViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
        guard let type = identifier as? String else { return }
        
        if (type == "changes") {
            self.save(cleanAll: false)
        }
        else if (type == "changesCleanAll") {
            self.save(cleanAll: true)
        }
    }
    
    func secondButtonPressed(identifier: Any?) {
        bottomSheetController?.dismiss(animated: true, completion: nil)
        guard let type = identifier as? String else { return }
        
        if (type == "changes") {
            self.hasChanges = false
            self.navigationController?.popViewController(animated: true)
            
        }
        else if (type == "changesCleanAll") {
            self.hasChanges = false
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
