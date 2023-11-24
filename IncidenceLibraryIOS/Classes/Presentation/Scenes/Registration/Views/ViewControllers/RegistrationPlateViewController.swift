//
//  RegistrationPlateViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class RegistrationPlateViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var nameTextFieldView: TextFieldView!

    let stepperView = StepperView()
    lazy var plateBottomSheetController: BottomSheetViewController = {
        let view = PlateBottomSheetView()
        view.configure(id:0, delegate: self)
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        return controller
    }()
    
    private var viewModel: RegistrationPlateViewModel! { get { return baseViewModel as? RegistrationPlateViewModel }}
    
    private var bottomSheetController: BottomSheetViewController?

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationPlateViewModel) -> RegistrationPlateViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationPlateViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        
        setUpHideKeyboardOnTap()
        
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        nameTextFieldView.delegate = self
        nameTextFieldView.placeholder = viewModel.inputPlaceholderText
        nameTextFieldView.title = viewModel.inputPlaceholderText
        nameTextFieldView.setKeyboard(.default)
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
        
        nameTextFieldView.becomeFirstResponder()
    }
    
    private func setUpStepperView() {
        switch viewModel.origin {
        case .editVehicle, .add:
            stepperView.totalStep = 2
        case .addBeacon:
            stepperView.totalStep = 1
        default:
            stepperView.totalStep = 3
        }
        
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 2
            stepperView.percentatge = 30
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        //present(plateBottomSheetController, animated: true, completion: nil)
        
        let licensePlate = nameTextFieldView.value ?? ""
        
        showHUD()
        Api.shared.validateLicensePlate(licensePlate: licensePlate, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vehicle = Core.shared.getVehicleCreating()
                vehicle.licensePlate = licensePlate
                
                self.goToNext()
            }
            else if let action = result.action, action == "license_plate_exists" {
                if let vehicleId = result.getString(key: "vehicleId") {
                    self.showTypeDriverPopUp(vehicleId)
                }
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    
    func goToNext()
    {
        
        let vm = RegistrationVehicleInfoViewModel(origin: self.viewModel.origin)
        let viewController = RegistrationVehicleInfoViewController.create(with: vm)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func showTypeDriverPopUp(_ vehicleId: String)
    {
        let title = "ask_you_are_this_vehicle_driver".localized()
        let message = "ask_you_are_this_vehicle_driver_desc".localized()
        let identifier = "plate_" + vehicleId
        
        let view = HomeBottomSheetView()
        view.configure(delegate: self, title: title, description: message, firstButtonText: "ask_you_are_this_vehicle_driver_yes".localized(), secondButtonText: "ask_you_are_this_vehicle_driver_no".localized(), secondButtonTextColor: MenuViewColors.red, identifier: identifier)
      
        let controller = BottomSheetViewController(contentView: view)
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .adaptive
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 44, left: 24, bottom: 24, right: 24)
        bottomSheetController = controller
        navigationController?.present(bottomSheetController!, animated: true, completion: nil)
    }
}

extension RegistrationPlateViewController: ButtonsBottomSheetDelegate {
    func firstButtonPressed(identifier: Any?) {
        if let identifier = identifier as? String, identifier.starts(with: "plate_") {
            bottomSheetController?.dismiss(animated: true, completion: {
                
                let vehicleId = identifier.components(separatedBy: "_")[1]
                let vm = SelectVehicleDriverTypeViewModel(vehicleId: vehicleId)
                let vc = SelectVehicleDriverTypeViewController.create(with: vm)
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    func secondButtonPressed(identifier: Any?) {
        if let identifier = identifier as? String, identifier.starts(with: "plate_") {
            bottomSheetController?.dismiss(animated: true, completion: {
                
                self.nameTextFieldView.value = ""
            })
        }
    }
}

extension RegistrationPlateViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = view.value,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            continueButton.isEnabled = updatedText.count > 0
                    
                }
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = nameTextFieldView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0
    }
}

extension RegistrationPlateViewController: PlateBottomSheetDelegate {
    func cancelButtonPressed(id: Int) {
        plateBottomSheetController.dismiss(animated: true, completion: nil)
    }
    
    func continueButtonPressed(id: Int)
    {
        plateBottomSheetController.dismiss(animated: true) { [weak self] in
            self!.goToNext()
        }
    }
    
    
    
}
