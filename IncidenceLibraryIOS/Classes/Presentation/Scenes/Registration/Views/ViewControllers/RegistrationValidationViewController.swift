//
//  RegistrationValidationViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import UIKit

class RegistrationValidationViewController: IABaseViewController, KeyboardDismiss, StoryboardInstantiable {
    
    static var storyboardFileName = "RegistrationScene"

    private var secondsRemaining = 780

    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var validatorView: ValidatorView!
    @IBOutlet weak var resendButton: TextButton!
    @IBOutlet weak var countdownLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
     
    
    private var viewModel: RegistrationValidationViewModel! { get { return baseViewModel as? RegistrationValidationViewModel }}
    
    let stepperView = StepperView()
    
    // MARK: - Lifecycle
    static func create(with viewModel: RegistrationValidationViewModel) -> RegistrationValidationViewController {
        let bundle = Bundle(for: Self.self)
        
        let view = RegistrationValidationViewController.instantiateViewController(bundle)
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpStepperView()
    }
    
    override func setUpUI() {
        super.setUpUI()
        helperLabel.text = viewModel.helperLabelText
        helperLabel.setLineSpacing(lineSpacing: 8, lineHeightMultiple: 0, aligment: .center)
        
        resendButton.setTitle(viewModel.resendButtonText, for: .normal)
        continueButton.setTitle(viewModel.continueButtonText, for: .normal)
        continueButton.isEnabled = false
        
        validatorView.delegate = self
        
        countdownLabel.isHidden = true
        
        setUpHideKeyboardOnTap()
        startTimer()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (Timer) in
            if self.secondsRemaining > 0 {
                countdownLabel.isHidden = false
                let seconds: Int = secondsRemaining % 60
                let minutes: Int = (secondsRemaining / 60) % 60
             
                self.countdownLabel.text = String(format:self.viewModel.countdownLabelText, minutes, seconds)
                self.secondsRemaining -= 1
            } else {
                Timer.invalidate()
                countdownLabel.isHidden = true
                
                self.validatorView.status = .error(text: "sms_code_timed_out".localized())
            }
        }
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
            stepperView.percentatge = 60
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        
        showHUD()
        Api.shared.generateCode(toEmail: false, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                self.startTimer()
                self.validatorView.clear()
            }
            else
            {
                self.onBadResponse(result: result)
            }
       })
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        let code = validatorView.value()
        
        showHUD()
        Api.shared.validateCode(code: code, completion: { result in
            self.hideHUD()
            if (result.isSuccess())
            {
                let vm = RegistrationIDViewModel()
                let viewController = RegistrationIDViewController.create(with: vm)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //self.onBadResponse(result: result)
                if (result != nil && result.message != nil)
                {
                    self.validatorView.status = .error(text: result.message ?? "")
                }
            }
       })
    }
}

extension RegistrationValidationViewController: ValidatorViewDelegate {
    func validatorViewCompletedCode(view: ValidatorView ) {
   
        let text = view.value()
        continueButton.isEnabled = text.count == 4
    }
}
