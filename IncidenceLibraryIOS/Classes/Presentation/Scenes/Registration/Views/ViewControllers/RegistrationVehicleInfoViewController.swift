//
//  RegistrationVehicleInfoViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//


import UIKit

class RegistrationVehicleInfoViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var plateInputTextView: TextFieldView!
    @IBOutlet weak var yearInputTextView: TextFieldView!
    @IBOutlet weak var brandInputTextView: TextFieldView!
    @IBOutlet weak var modelInputTextView: TextFieldView!
    
    let stepperView = StepperView()
    
    private var viewModel: RegistrationVehicleInfoViewModel! { get { return baseViewModel as? RegistrationVehicleInfoViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationVehicleInfoViewModel) -> RegistrationVehicleInfoViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationVehicleInfoViewController .instantiateViewController(bundle)
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
        setUpKeyboardObservers()
        
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        plateInputTextView.placeholder = viewModel.inputPlatePlaceholderText
        plateInputTextView.title = viewModel.inputPlatePlaceholderText
        plateInputTextView.showSuccess = true
        plateInputTextView.isEnabled = false
        plateInputTextView.delegate = self
        
        yearInputTextView.placeholder = viewModel.inputYearPlaceholderText
        yearInputTextView.title = viewModel.inputYearPlaceholderText
        yearInputTextView.showSuccess = true
        yearInputTextView.delegate = self
        yearInputTextView.setMaxLength(4)
        yearInputTextView.setKeyboard(.numberPad) 
        
        brandInputTextView.placeholder = viewModel.inputBrandPlaceholderText
        brandInputTextView.title = viewModel.inputBrandPlaceholderText
        brandInputTextView.showSuccess = true
        brandInputTextView.delegate = self
        
        modelInputTextView.placeholder = viewModel.inputModelPlaceholderText
        modelInputTextView.title = viewModel.inputModelPlaceholderText
        modelInputTextView.showSuccess = true
        modelInputTextView.delegate = self
        
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
    }
    
    override func loadData() {
        let vehicle = Core.shared.getVehicleCreating()
        plateInputTextView.value = vehicle.licensePlate
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
            stepperView.percentatge = 45
        }
        
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let vehicle = Core.shared.getVehicleCreating()
        if let year = yearInputTextView.value {
            vehicle.registrationYear = Int(year)
        }
        vehicle.brand = brandInputTextView.value
        vehicle.model = modelInputTextView.value
        
        
        if let year = yearInputTextView.value, year.count > 0
        {
            showHUD()
            Api.shared.validateYear(value: year, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    let vm = RegistrationColorViewModel(origin: self.viewModel.origin, vehicleColors: vehicle.vehicleType?.colors ?? [], selectedColor: nil)
                    let viewController = RegistrationColorViewController.create(with: vm)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else
                {
                    self.onBadResponse(result: result)
                }
           })
        }
        else
        {
            let vm = RegistrationColorViewModel(origin: viewModel.origin, vehicleColors: vehicle.vehicleType?.colors ?? [], selectedColor: nil)
            let viewController = RegistrationColorViewController.create(with: vm)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension RegistrationVehicleInfoViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text1 = plateInputTextView.value
        var text2 = yearInputTextView.value
        var text3 = brandInputTextView.value
        var text4 = modelInputTextView.value
        
        if let text = view.value,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if (view == plateInputTextView) {
                text1 = updatedText
            }
            else if (view == yearInputTextView) {
                text2 = updatedText
            }
            else if (view == brandInputTextView) {
                text3 = updatedText
            }
            else if (view == modelInputTextView) {
                text4 = updatedText
            }
        }
        
        continueButton.isEnabled = text1?.count ?? 0 > 0 /*&& text2?.count ?? 0 > 0*/ && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = plateInputTextView.value
        let text2 = yearInputTextView.value
        let text3 = brandInputTextView.value
        let text4 = modelInputTextView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0 /*&& text2?.count ?? 0 > 0*/ && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
    }
}
