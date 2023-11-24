//
//  RegistrationInsuranceInfoViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class RegistrationInsuranceInfoViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helperLabel: TextLabel! 
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var InsuranceFieldView: TextFieldView!
    @IBOutlet weak var numberFieldView: TextFieldView!
    @IBOutlet weak var idFieldView: TextFieldWithSelectView!
    @IBOutlet weak var expirationFieldView: TextFieldView!
    @IBOutlet weak var laterButton: TextButton!
    
    
    let stepperView = StepperView()
    
    private var viewModel: RegistrationInsuranceInfoViewModel! { get { return baseViewModel as? RegistrationInsuranceInfoViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationInsuranceInfoViewModel) -> RegistrationInsuranceInfoViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationInsuranceInfoViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
        setUpKeyboardObservers()
    }

    override func setUpUI() {
        super.setUpUI()
        
        setUpHideKeyboardOnTap()
        
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        InsuranceFieldView.placeholder = viewModel.insuranceFieldViewText
        InsuranceFieldView.title = viewModel.insuranceFieldViewText
        InsuranceFieldView.showSuccess = true
        InsuranceFieldView.isEnabled = false
        
        numberFieldView.placeholder = viewModel.numberFieldViewText
        numberFieldView.title = viewModel.numberFieldViewText
        numberFieldView.delegate = self
        //numberFieldView.showSuccess = true
        
        idFieldView.configure(options: ["nif".localized(), "nie".localized(), "cif".localized()])
        idFieldView.placeholder = viewModel.dniFieldViewText
        idFieldView.title = viewModel.dniFieldViewText
        idFieldView.delegate = self
        //idFieldView.showSuccess = true
        
        expirationFieldView.placeholder = viewModel.expirationFieldViewText
        expirationFieldView.title = viewModel.expirationFieldViewText
        expirationFieldView.delegate = self
        expirationFieldView.setUpDatePicker()
        //expirationFieldView.showSuccess = true
        
        laterButton.setTitle(viewModel.laterButtonText, for: .normal)
        
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
    }
    
    override func loadData() {
        let vehicle = Core.shared.getVehicleCreating()
        InsuranceFieldView.value = vehicle.insurance?.name
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
            stepperView.percentatge = 85
        }
        
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        var identityType:String? = idFieldView.valueOption
        if (identityType == "cif".localized()) {
            identityType = "3"
        } else if (identityType == "nie".localized()) {
            identityType = "2"
        } else {
            identityType = "1"
        }
        
        let iden = IdentityType()
        iden.id = Int(identityType ?? "1")
        iden.name = idFieldView.valueOption ?? "DNI"
        
        let policy = Policy()
        policy.identityType = iden
        policy.dni = idFieldView.value
        policy.policyNumber = numberFieldView.value
        let birthday:String? = DateUtils.dateStringSpanishToInternational(expirationFieldView.value)
        policy.policyEnd = birthday
        
        
        showHUD()
        if (policy.identityType?.id == 1)
        {
            Api.shared.validateDNI(value: policy.dni ?? "", completion: { result in
                if (result.isSuccess())
                {
                    self.sendData(policy)
                }
                else
                {
                    self.hideHUD()
                    self.onBadResponse(result: result)
                }
           })
        }
        else if (policy.identityType?.id == 3)
        {
            Api.shared.validateCIF(value: policy.dni ?? "", completion: { result in
                if (result.isSuccess())
                {
                    self.sendData(policy)
                }
                else
                {
                    self.hideHUD()
                    self.onBadResponse(result: result)
                }
           })
        }
        else
        {
            Api.shared.validateNIE(value: policy.dni ?? "", completion: { result in
                if (result.isSuccess())
                {
                    self.sendData(policy)
                }
                else
                {
                    self.hideHUD()
                    self.onBadResponse(result: result)
                }
           })
        }
    }
    
    @IBAction func laterButtonPressed(_ sender: Any) {
        
        let vehicle = Core.shared.getVehicleCreating()
        if vehicle.insurance != nil {
            
            Api.shared.addVehicleInsurance(vehicle: vehicle, completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    EventNotification.post(code: .VEHICLE_ADDED)
                    self.goToNext()
                }
                else
                {
                    self.onBadResponse(result: result)
                }
            })
        }
        else
        {
            EventNotification.post(code: .VEHICLE_ADDED)
            self.goToNext()
        }
    }
    
    func sendData(_ policy:Policy)
    {
        let vehicle = Core.shared.getVehicleCreating()
        
        Api.shared.addVehiclePolicy(vehicle: vehicle, policy: policy, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                EventNotification.post(code: .VEHICLE_ADDED)
                self.goToNext()
            }
            else
            {
                self.onBadResponse(result: result)
            }
        })
    }
    
    func goToNext()
    {
        if viewModel.origin == .add {
            
            if Core.shared.getVehicleCreatingBecomeFromAddBeacon() {
                if let vc = self.navigationController?.viewControllers.filter({$0 is AddBeaconToCarViewController}).first {
                    let addBeaconToCarViewController = vc as! AddBeaconToCarViewController
                    addBeaconToCarViewController.loadData()
                    self.navigationController?.popToViewController(addBeaconToCarViewController, animated: true)
                }
                else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            else
            {
                let vm = RegistrationBeaconViewModel(origin: .addBeacon)
                let vehicle = Core.shared.getVehicleCreating()
                vm.autoSelectedVehicle = vehicle
                let viewController = RegistrationBeaconSelectTypeViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else
        {
            let vm = RegistrationStepsViewModel(completedSteps: [.personalData, .carAndInsurance], origin: viewModel.origin)
            let viewController = RegistrationStepsViewController.create(with: vm)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension RegistrationInsuranceInfoViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text1 = InsuranceFieldView.value
        var text2 = numberFieldView.value
        var text3 = idFieldView.value
        var text4 = expirationFieldView.value
        
        if let text = view.value,
                   let textRange = Range(range, in: text) {
                   let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if (view == InsuranceFieldView) {
                text1 = updatedText
            }
            else if (view == numberFieldView) {
                text2 = updatedText
            }
            else if (view == idFieldView) {
                text3 = updatedText
            }
            else if (view == expirationFieldView) {
                text4 = updatedText
            }
        }
        
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0 && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
        
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = InsuranceFieldView.value
        let text2 = numberFieldView.value
        let text3 = idFieldView.value
        let text4 = expirationFieldView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0 && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
    }
}

extension RegistrationInsuranceInfoViewController: TextFieldWithSelectViewDelegate {
    func textFieldView(view: TextFieldWithSelectView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        let text1 = InsuranceFieldView.value
        let text2 = numberFieldView.value
        var text3 = idFieldView.value
        let text4 = expirationFieldView.value
        
        if let text = textfield.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //nameTextFieldView.showSuccess = updatedText.count == 3
            
            text3 = updatedText
        }
        
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0 && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
        
        return true
    }
    
    func dropTextFieldShouldClear(_ textField: UITextField) {
        let text1 = InsuranceFieldView.value
        let text2 = numberFieldView.value
        let text3 = idFieldView.value
        let text4 = expirationFieldView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0 && text2?.count ?? 0 > 0 && text3?.count ?? 0 > 0 && text4?.count ?? 0 > 0
    }
}


