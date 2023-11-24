//
//  VehiclesInfoEditViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import UIKit

class VehiclesInfoEditViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var plateTextFieldView: TextFieldView!
    @IBOutlet weak var yearTextFieldView: TextFieldView!
    @IBOutlet weak var brandTextFieldView: TextFieldView!
    @IBOutlet weak var modelTextFieldView: TextFieldView!
    @IBOutlet weak var colorTextFieldView: TextFieldView!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var cancelButton: TextButton!
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    
    static var storyboardFileName = "VehiclesScene"
    private var viewModel: VehiclesInfoEditViewModel! { get { return baseViewModel as? VehiclesInfoEditViewModel }}
    
    
    private var registrationColorViewModel:RegistrationColorViewModel?
    private var selectedColor:ColorType?
    
    private var hasChanges = false
    private var bottomSheetController: BottomSheetViewController?

    
    // MARK: - Lifecycle
    static func create(with viewModel: VehiclesInfoEditViewModel) -> VehiclesInfoEditViewController {
        let view = VehiclesInfoEditViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (registrationColorViewModel != nil)
        {
            if (selectedColor?.id != registrationColorViewModel?.selectedColor?.id)
            {
                selectedColor = registrationColorViewModel?.selectedColor
                colorTextFieldView.value = selectedColor?.name ?? ""
                self.hasChanges = true
            }
            
            registrationColorViewModel = nil
        }
    }

    override func setUpUI() {
        super.setUpUI()
        setUpNavigation()
        setUpHideKeyboardOnTap()
        setUpKeyboardObservers()
        
        continueButton.setTitle(viewModel.saveButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelButtonText, for: .normal)

        plateTextFieldView.isEnabled = false
        plateTextFieldView.showEditable = false
        plateTextFieldView.showSuccess = false
        plateTextFieldView.placeholder = viewModel.plateFieldViewTitle
        plateTextFieldView.title = viewModel.plateFieldViewTitle
        
        yearTextFieldView.showEditable = true
        yearTextFieldView.delegate = self
        yearTextFieldView.showSuccess = false
        yearTextFieldView.placeholder = viewModel.yearFieldViewTitle
        yearTextFieldView.title = viewModel.yearFieldViewTitle
        
        brandTextFieldView.showEditable = true
        brandTextFieldView.delegate = self
        brandTextFieldView.showSuccess = false
        brandTextFieldView.placeholder = viewModel.brandFieldViewTitle
        brandTextFieldView.title = viewModel.brandFieldViewTitle
        
        modelTextFieldView.showEditable = true
        modelTextFieldView.delegate = self
        modelTextFieldView.showSuccess = false
        modelTextFieldView.placeholder = viewModel.modelFieldViewTitle
        modelTextFieldView.title =  viewModel.modelFieldViewTitle
        
        colorTextFieldView.showEditable = true
        colorTextFieldView.showSuccess = false
        colorTextFieldView.placeholder = viewModel.colorFieldViewTitle
        colorTextFieldView.title = viewModel.colorFieldViewTitle
        colorTextFieldView.delegate = self
    }
    
    override func loadData() {
        plateTextFieldView.value = viewModel.vehicle.licensePlate ?? ""
        if let year = viewModel.vehicle.registrationYear {
            yearTextFieldView.value = String(year)
        }
        brandTextFieldView.value = viewModel.vehicle.brand ?? ""
        modelTextFieldView.value = viewModel.vehicle.model ?? ""
        
        selectedColor = viewModel.vehicle.color
        if (selectedColor != nil) {
            colorTextFieldView.value = selectedColor?.name ?? ""
        }
        else {
            colorTextFieldView.value = ""
        }
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
        newVehicle.licensePlate = plateTextFieldView.value
        if let year = yearTextFieldView.value {
            newVehicle.registrationYear = Int(year)
        }
        newVehicle.brand = brandTextFieldView.value
        newVehicle.model = modelTextFieldView.value
        newVehicle.color = selectedColor
        
        showHUD()
        Api.shared.updateVehicle(vehicle: newVehicle, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.hasChanges = false
                
                let vehicle:Vehicle? = result.get(key: "vehicle")
                Core.shared.saveVehicle(vehicle: vehicle)
                EventNotification.post(code: .VEHICLE_UPDATED, object: vehicle)
                
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

extension VehiclesInfoEditViewController: TextFieldViewDelegate {
    func textFieldShouldBeginEditing(view: TextFieldView) -> Bool {
        
        if (view == colorTextFieldView)
        {
            colorTextFieldView.resignFirstResponder()
            
            //para intentar que no ocurra que se abre 2 veces. A nosotros no nos pasa, solo nos mandan un video.
            if let topVC = self.navigationController?.topViewController {
                if (topVC.isKind(of: RegistrationColorViewController.self)) {
                    return false
                }
            }
            
            
            var vehicleColors = [ColorType]()
            var tempSelectedColor:ColorType? = nil
            let vehicleType = Core.shared.getVehicleType(viewModel.vehicle.vehicleType?.id ?? 0)
            if (vehicleType != nil && vehicleType?.colors != nil) {
                vehicleColors = (vehicleType?.colors)!
                tempSelectedColor = Core.shared.getColorType(vehicleType: vehicleType, id: selectedColor?.id ?? 0)
            }
            
            registrationColorViewModel = RegistrationColorViewModel(origin: .editVehicle, vehicleColors: vehicleColors, selectedColor: tempSelectedColor)
            let vc = RegistrationColorViewController.create(with: registrationColorViewModel!)
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

extension VehiclesInfoEditViewController: ButtonsBottomSheetDelegate {
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
