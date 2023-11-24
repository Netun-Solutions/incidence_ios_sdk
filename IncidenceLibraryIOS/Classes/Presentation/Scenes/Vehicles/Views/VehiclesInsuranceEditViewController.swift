//
//  VehiclesInsuranceEditViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesInsuranceEditViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var insuranceTextFieldView: TextFieldView!
    @IBOutlet weak var idInsuranceTextFieldView: TextFieldView!
    @IBOutlet weak var idOwnerTextFieldView: TextFieldWithSelectView!
    @IBOutlet weak var expirationTextFieldView: TextFieldView!
    
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesInsuranceEditViewModel! { get { return baseViewModel as? VehiclesInsuranceEditViewModel }}
    
    private var registrationInsuranceViewModel:RegistrationInsuranceViewModel?
    private var selectedInsurance:Insurance?
    
    private var hasChanges = false
    private var bottomSheetController: BottomSheetViewController?
    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesInsuranceEditViewModel) -> VehiclesInsuranceEditViewController {
        let view = VehiclesInsuranceEditViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (registrationInsuranceViewModel != nil)
        {
            if let sel = registrationInsuranceViewModel?.selectedInsurance {
                selectedInsurance = sel
                insuranceTextFieldView.value = selectedInsurance?.name ?? ""
                registrationInsuranceViewModel = nil
                self.hasChanges = true
            }
        }
    }
    
    override func setUpUI() {
        super.setUpUI()
        setUpNavigation()
        
        setUpHideKeyboardOnTap()
        setUpKeyboardObservers()
        
        continueButton.setTitle(viewModel.saveButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)

        insuranceTextFieldView.showEditable = true
        insuranceTextFieldView.showSuccess = false
        insuranceTextFieldView.value = ""
        insuranceTextFieldView.placeholder = viewModel.insuranceFieldViewTitle
        insuranceTextFieldView.title = viewModel.insuranceFieldViewTitle
        insuranceTextFieldView.delegate = self
        
        idInsuranceTextFieldView.showEditable = true
        idInsuranceTextFieldView.showSuccess = false
        idInsuranceTextFieldView.value = ""
        idInsuranceTextFieldView.placeholder = viewModel.idInsuranceFieldViewTitle
        idInsuranceTextFieldView.title = viewModel.idInsuranceFieldViewTitle
        idInsuranceTextFieldView.delegate = self
        
        idOwnerTextFieldView.configure(options: ["nif".localized(), "nie".localized(), "cif".localized()])
        //idOwnerTextFieldView.delegate = self
        idOwnerTextFieldView.showEditable = true
        idOwnerTextFieldView.showSuccess = false
        idOwnerTextFieldView.value = ""
        idOwnerTextFieldView.placeholder = viewModel.idOwnerFieldViewTitle
        idOwnerTextFieldView.title = viewModel.idOwnerFieldViewTitle
        idOwnerTextFieldView.delegate = self
        
        expirationTextFieldView.showEditable = true
        expirationTextFieldView.showSuccess = false
        expirationTextFieldView.value = ""
        expirationTextFieldView.setUpDatePicker()
        expirationTextFieldView.placeholder = viewModel.expirationFieldViewTitle
        expirationTextFieldView.title = viewModel.expirationFieldViewTitle
        expirationTextFieldView.delegate = self
    }
    
    override func loadData() {
        insuranceTextFieldView.value = viewModel.vehicle.insurance?.name
        idInsuranceTextFieldView.value = viewModel.vehicle.policy?.policyNumber
        idOwnerTextFieldView.value = viewModel.vehicle.policy?.dni
        expirationTextFieldView.value = DateUtils.dateStringInternationalToSpanish(viewModel.vehicle.policy?.policyEnd)
        
        if (viewModel.vehicle.policy?.identityType?.id == 2)
        {
            idOwnerTextFieldView.configure(options: ["nie".localized(), "nif".localized(), "cif".localized()])
        }
        else if (viewModel.vehicle.policy?.identityType?.id == 3)
        {
            idOwnerTextFieldView.configure(options: ["cif".localized(), "nif".localized(), "nie".localized()])
        }
        
        
        selectedInsurance = viewModel.vehicle.insurance
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage.app( "Close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closePressed))
        closeButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closePressed() {
        if (hasChanges) {
            showSavePopUp(cleanAll: true)
        }
        else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if (hasChanges) {
            showSavePopUp(cleanAll: false)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func backPressed(){
        if (hasChanges) {
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
        
        let newVehicle = Vehicle(viewModel.vehicle)
        newVehicle.insurance = selectedInsurance
        
        let policy = Policy()
        //policy.identityType = newVehicle.policy?.identityType
        
        let idnetityType = IdentityType()
        
        let ident:String? = idOwnerTextFieldView.valueOption
        if (ident == "cif".localized()) {
            idnetityType.id = 3
        } else if (ident == "nie".localized()) {
            idnetityType.id = 2
        } else {
            idnetityType.id = 1
        }
        idnetityType.name = ident ?? ""
        policy.identityType = idnetityType
        
        policy.dni = idOwnerTextFieldView.value
        policy.policyNumber = idInsuranceTextFieldView.value
        var birthday:String? = DateUtils.dateStringSpanishToInternational(expirationTextFieldView.value)
        if (birthday != nil && birthday == "-") {
            birthday = nil
        }
        policy.policyEnd = birthday
        
        
        
        showHUD()
        Api.shared.addVehiclePolicy(vehicle: newVehicle, policy: policy, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.hasChanges = false
                
                newVehicle.policy = result.get(key: "policy")
                Core.shared.saveVehicle(vehicle: newVehicle)
                EventNotification.post(code: .VEHICLE_UPDATED, object: newVehicle)
                
                self.navigationController?.popViewController(animated: true)
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

extension VehiclesInsuranceEditViewController: TextFieldViewDelegate {
    func textFieldShouldBeginEditing(view: TextFieldView) -> Bool {
        
        if (view == insuranceTextFieldView)
        {
            insuranceTextFieldView.resignFirstResponder()
            
            //para intentar que no ocurra que se abre 2 veces. A nosotros no nos pasa, solo nos mandan un video.
            if let topVC = self.navigationController?.topViewController {
                if (topVC.isKind(of: RegistrationInsuranceViewController.self)) {
                    return false
                }
            }
            
            registrationInsuranceViewModel = RegistrationInsuranceViewModel(origin: .editInsurance)
            registrationInsuranceViewModel?.vehicle = self.viewModel.vehicle
            let vc = RegistrationInsuranceViewController.create(with: registrationInsuranceViewModel!)
            navigationController?.pushViewController(vc, animated: true)
            
            return false
        }
        
        return true
    }
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hasChanges = true
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        hasChanges = true
    }
}

extension VehiclesInsuranceEditViewController: TextFieldWithSelectViewDelegate {
    func textFieldView(view: TextFieldWithSelectView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        hasChanges = true
        
        return true
    }
    func dropTextFieldShouldClear(_ textField: UITextField) {
        hasChanges = true
    }
}

extension VehiclesInsuranceEditViewController: ButtonsBottomSheetDelegate {
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
