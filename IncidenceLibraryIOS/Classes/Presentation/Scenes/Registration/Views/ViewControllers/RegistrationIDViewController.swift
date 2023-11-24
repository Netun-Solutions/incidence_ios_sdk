//
//  RegistrationIDViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation
import UIKit

class RegistrationIDViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var inputTextFieldView: TextFieldWithSelectView!
    

    private var viewModel: RegistrationIDViewModel! { get { return baseViewModel as? RegistrationIDViewModel }}

    let stepperView = StepperView()
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationIDViewModel) -> RegistrationIDViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationIDViewController .instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }

    override func setUpUI() {
        super.setUpUI()
        inputTextFieldView.configure(options: ["nif".localized(), "nie".localized(), "cif".localized()])
        inputTextFieldView.placeholder = "nif_doc_identity".localized()
        inputTextFieldView.title = "nif_doc_identity".localized()
        inputTextFieldView.delegate = self
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
    }
    
    private func setUpStepperView() {
        navigationController?.view.subviews.first(where: { (view) -> Bool in
            return view is StepperView
            })?.removeFromSuperview()

        navigationController?.view.addSubview(stepperView)
            
        if let view = navigationController?.navigationBar {
            stepperView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            stepperView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
            stepperView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
            stepperView.anchorCenterXToSuperview()
            stepperView.currentStep = 1
            stepperView.percentatge = 75
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        var identityType:String? = inputTextFieldView.valueOption
        if (identityType == "cif".localized()) {
            identityType = "3"
        } else if (identityType == "nie".localized()) {
            identityType = "2"
        } else {
            identityType = "1"
        }
        
        let iden = IdentityType()
        iden.id = Int(identityType ?? "1")
        iden.name = inputTextFieldView.valueOption ?? "DNI"
        
        let user = Core.shared.getUserCreating()
        user.dni = inputTextFieldView.value
        user.identityType = iden
        
        
        
        if (user.identityType?.id == 1)
        {
            showHUD()
            Api.shared.validateDNI(value: user.dni ?? "", completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    let action:String? = result.getString(key: "action")
                    let message:String? = result.getString(key: "message")
                    
                    if (action != nil && action == Constants.VALIDATE_USER_DNI_EXISTS)
                    {
                        self.inputTextFieldView.status = .error(text: message ?? "")
                    }
                    else
                    {
                        let vm = RegistrationEmailViewModel()
                        let viewController = RegistrationEmailViewController.create(with: vm)
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                else
                {
                    //self.onBadResponse(result: result)
                    if (result != nil && result.message != nil)
                    {
                        self.inputTextFieldView.status = .error(text: result.message ?? "")
                    }
                }
           })
        }
        else
        {
            showHUD()
            Api.shared.validateNIE(value: user.dni ?? "", completion: { result in
                self.hideHUD()
                if (result.isSuccess())
                {
                    let action:String? = result.getString(key: "action")
                    let message:String? = result.getString(key: "message")
                    
                    if (action != nil && action == Constants.VALIDATE_USER_NIE_EXISTS)
                    {
                        self.inputTextFieldView.status = .error(text: message ?? "")
                    }
                    else
                    {
                        let vm = RegistrationEmailViewModel()
                        let viewController = RegistrationEmailViewController.create(with: vm)
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
                else
                {
                    //self.onBadResponse(result: result)
                    if (result != nil && result.message != nil)
                    {
                        self.inputTextFieldView.status = .error(text: result.message ?? "")
                    }
                }
           })
        }
    }

}

extension RegistrationIDViewController: TextFieldWithSelectViewDelegate {
    func textFieldView(view: TextFieldWithSelectView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        if let text = textfield.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //nameTextFieldView.showSuccess = updatedText.count == 3
            continueButton.isEnabled = updatedText.count > 0
        }
        
        return true
    }
    
    func dropTextFieldShouldClear(_ textField: UITextField) {
        let text1 = inputTextFieldView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0
    }
}

