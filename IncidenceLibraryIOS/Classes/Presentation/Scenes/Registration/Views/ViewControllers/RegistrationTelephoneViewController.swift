//
//  RegistrationTelephoneViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

class RegistrationTelephoneViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "RegistrationScene"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var nameTextFieldView: TextFieldView!

    let stepperView = StepperView()
    
    private var viewModel: RegistrationTelephoneViewModel! { get { return baseViewModel as? RegistrationTelephoneViewModel }}

    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationTelephoneViewModel) -> RegistrationTelephoneViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationTelephoneViewController .instantiateViewController(bundle)
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
        
        nameTextFieldView.placeholder = viewModel.placeholderInputViewText
        nameTextFieldView.title = viewModel.placeholderInputViewText
        nameTextFieldView.setKeyboard(.phonePad)
        nameTextFieldView.delegate = self
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
        
        nameTextFieldView.becomeFirstResponder()
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
            stepperView.percentatge = 30
        }
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let user = Core.shared.getUserCreating()
        user.phone = nameTextFieldView.value
        
        showHUD()
        Api.shared.validatePhone(value: user.phone ?? "", completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let action:String? = result.getString(key: "action")
                let message:String? = result.getString(key: "message")
                
                if (action != nil && action == Constants.VALIDATE_USER_PHONE_EXISTS)
                {
                    self.nameTextFieldView.status = .error(text: message ?? "")
                }
                else
                {
                    let vm = RegistrationTermsViewModel()
                    let viewController = RegistrationTermsViewController.create(with: vm)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else
            {
                //self.onBadResponse(result: result)
                if (result != nil && result.message != nil)
                {
                    self.nameTextFieldView.status = .error(text: result.message ?? "")
                }
            }
       })
    }

}

extension RegistrationTelephoneViewController: TextFieldViewDelegate {
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
    
    func textFieldShouldEndEditing(view: TextFieldView) -> Bool {
        
        if let value = nameTextFieldView.value, value.isValidPhone() {
            nameTextFieldView.showSuccess = true
        }
        else
        {
            nameTextFieldView.showSuccess = false
        }
        
        return true
    }
}
