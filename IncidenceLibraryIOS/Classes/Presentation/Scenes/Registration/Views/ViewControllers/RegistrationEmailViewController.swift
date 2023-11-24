//
//  RegistrationEmailViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation
import UIKit

class RegistrationEmailViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss {

    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var nameTextFieldView: TextFieldView!

    let stepperView = StepperView()
    
    private var viewModel: RegistrationEmailViewModel! { get { return baseViewModel as? RegistrationEmailViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationEmailViewModel) -> RegistrationEmailViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationEmailViewController .instantiateViewController(bundle)
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
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        nameTextFieldView.placeholder = viewModel.placeholderInputViewText
        nameTextFieldView.title = viewModel.placeholderInputViewText
        nameTextFieldView.setKeyboard(.emailAddress)
        nameTextFieldView.delegate = self
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
            stepperView.percentatge = 90
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let user = Core.shared.getUserCreating()
        user.email = nameTextFieldView.value
        if let em = user.email {
            user.email = em.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        
        showHUD()
        Api.shared.validateEmail(value: user.email ?? "", completion: { result in
            
            if (result.isSuccess())
            {
                let action:String? = result.getString(key: "action")
                let message:String? = result.getString(key: "message")
                
                if (action != nil && action == Constants.VALIDATE_USER_EMAIL_EXISTS)
                {
                    self.hideHUD()
                    self.nameTextFieldView.status = .error(text: message ?? "")
                }
                else
                {
                    Api.shared.updateUser(name: user.name, phone: user.phone, identityType: String(user.identityType?.id ?? 1), dni: user.dni, email: user.email, birthday: user.birthday, completion: { result in
                        self.hideHUD()
                        if (result.isSuccess())
                        {
                            let vm = RegistrationStepsViewModel(completedSteps: [.personalData], origin: .registration)
                            let viewController = RegistrationStepsViewController.create(with: vm)
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                        else
                        {
                            self.onBadResponse(result: result)
                        }
                   })
                }
            }
            else
            {
                self.hideHUD()
                //self.onBadResponse(result: result)
                if (result != nil && result.message != nil)
                {
                    self.nameTextFieldView.status = .error(text: result.message ?? "")
                }
            }
       })
    }

}

extension RegistrationEmailViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        if let text = textfield.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //nameTextFieldView.showSuccess = updatedText.count == 3
            continueButton.isEnabled = updatedText.count > 0
        }
        
        return true
    }
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = nameTextFieldView.value
        continueButton.isEnabled = text1?.count ?? 0 > 0
    }
}
