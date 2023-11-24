//
//  SignInViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 22/4/21.
//

import UIKit

class SignInViewController: IABaseViewController, KeyboardDismiss, StoryboardInstantiable {
    
    static var storyboardFileName = "SignInScene"
    
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var inputTextField: TextFieldView!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var switchSignInType: TextButton!
    @IBOutlet weak var createAccountLabel: TextLabel!
    @IBOutlet weak var createAccountButton: TextButton!
    
    private var viewModel: SignInViewModel! { get { return baseViewModel as? SignInViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: SignInViewModel) -> SignInViewController {
        let view = SignInViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }

    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        helperLabel.isHidden = false
        inputTextField.placeholder = viewModel.inputTitleText
        inputTextField.title = viewModel.inputTitleText
        inputTextField.setKeyboard(viewModel.viewType == .email ? .emailAddress : .phonePad)
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
        switchSignInType.setTitle(viewModel.switchButtonText, for: .normal)
        createAccountLabel.text = viewModel.createAccountLabelText
        createAccountButton.setTitle(viewModel.createAccountButtonText, for: .normal)
        
        inputTextField.delegate = self
        
        setUpHideKeyboardOnTap()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let email:String? = viewModel.viewType == .email ? inputTextField.value : nil
        let phone:String? = viewModel.viewType == .telephone ? inputTextField.value : nil
        
        showHUD()
        Api.shared.signIn(email: email, phone: phone, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vm = SignInValidationViewModel(viewType: self.viewModel.viewType)
                let viewController = SignInValidationViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //self.onBadResponse(result: result)
                if (result != nil && result.message != nil)
                {
                    self.inputTextField.status = .error(text: result.message ?? "")
                }
            }
       })
    }
    
    @IBAction func switchSignInTypePressed(_ sender: Any) {
        let vm = SignInViewModel(viewType: viewModel.viewType == .email ? .telephone : .email)
        let viewController = SignInViewController.create(with: vm)
        navigationController?.setViewControllers([viewController], animated: false)
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        let vm = RegistrationStepsViewModel(completedSteps: [], origin: .registration, presentOnboarding: false)
        let viewController = RegistrationStepsViewController.create(with: vm)
        navigationController?.setViewControllers([viewController], animated: false)
    }
}

extension SignInViewController: TextFieldViewDelegate {
    func textFieldView(view: TextFieldView, textfield: UITextField, status: InputViewStatus) {
        //helperLabel.isHidden = textfield.text?.count == 0
    }
    func textFieldView(view: TextFieldView, textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textfield.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            continueButton.isEnabled = updatedText.count > 0
        }
        return true
    }
    
    func textFieldShouldClear(view: TextFieldView) {
        let text1 = inputTextField.value
        continueButton.isEnabled = text1?.count ?? 0 > 0
    }
    
    func textFieldShouldEndEditing(view: TextFieldView) -> Bool {
        
        if (viewModel.viewType == .telephone)
        {
            if let value = inputTextField.value, value.isValidPhone() {
                inputTextField.showSuccess = true
            }
            else
            {
                inputTextField.showSuccess = false
            }
        }
        else if (viewModel.viewType == .email)
        {
            if let value = inputTextField.value, value.isValidEmail() {
                inputTextField.showSuccess = true
            }
            else
            {
                inputTextField.showSuccess = false
            }
        }
        
        return true
    }
}
