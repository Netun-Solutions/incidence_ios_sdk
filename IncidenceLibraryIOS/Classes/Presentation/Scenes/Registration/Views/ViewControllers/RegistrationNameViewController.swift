//
//  RegistrationNameViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//


import UIKit

class RegistrationNameViewController: IABaseViewController, StoryboardInstantiable, KeyboardDismiss, KeyboardListener {
    
    var contentInsetPreKeyboardDisplay: UIEdgeInsets?
    static var storyboardFileName = "RegistrationScene"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    @IBOutlet weak var nameTextFieldView: TextFieldView!
    
    let stepperView = StepperView()
    
    private var viewModel: RegistrationNameViewModel! { get { return baseViewModel as? RegistrationNameViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationNameViewModel) -> RegistrationNameViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationNameViewController .instantiateViewController(bundle)
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
        nameTextFieldView.delegate = self
        
        //nameTextFieldView.status = .error(text: "Esto es un error")
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
            stepperView.percentatge = 15
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        Core.shared.initUserCreating()
        let user = Core.shared.getUserCreating()
        user.name = nameTextFieldView.value
        
        let vm = RegistrationTelephoneViewModel()
        let viewController = RegistrationTelephoneViewController.create(with: vm)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RegistrationNameViewController: TextFieldViewDelegate {
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
