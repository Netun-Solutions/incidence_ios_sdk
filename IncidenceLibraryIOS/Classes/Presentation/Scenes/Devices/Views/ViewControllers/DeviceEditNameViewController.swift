//
//  DeviceEditViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import UIKit

class DeviceEditViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextFieldView: TextFieldView!
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "DevicesScene"
    private var viewModel: DeviceEditNameViewModel! { get { return baseViewModel as? DeviceEditNameViewModel }}
    
    private var hasChanges = false
    private var bottomSheetController: BottomSheetViewController?

    
    // MARK: - Lifecycle
    static func create(with viewModel: DeviceEditNameViewModel) -> DeviceEditViewController {
        let view = DeviceEditViewController.instantiateViewController()
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

        nameTextFieldView.delegate = self
        nameTextFieldView.showEditable = true
        nameTextFieldView.showSuccess = false
        nameTextFieldView.value = viewModel.device?.name
        nameTextFieldView.title = viewModel.fieldNameTitle
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
    
    private func save(cleanAll: Bool)
    {
        let name = nameTextFieldView.value
        
        showHUD()
        Api.shared.updateVehicleBeacon(beacon: self.viewModel.device!, newName: name!, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.hasChanges = false
                
                self.viewModel.device?.name = name
                EventNotification.post(code: .BEACON_UPDATED, object: self.viewModel.device)
                
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

extension DeviceEditViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        var text1 = nameTextFieldView.value
        
        
        if let text = view.value,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            text1 = updatedText
        }
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = nameTextFieldView.value
        
        hasChanges = true
        continueButton.isEnabled = text1?.count ?? 0 > 0
    }
}

extension DeviceEditViewController: ButtonsBottomSheetDelegate {
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
