//
//  SignInValidationViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import UIKit

class SignInValidationViewController: IABaseViewController, KeyboardDismiss, StoryboardInstantiable {
    
    static var storyboardFileName = "SignInScene"

    private var secondsRemaining = 780

    @IBOutlet weak var titleLabel: TextLabel!
    @IBOutlet weak var helperLabel: TextLabel!
    @IBOutlet weak var validatorView: ValidatorView!
    @IBOutlet weak var resendButton: TextButton!
    @IBOutlet weak var countdownLabel: TextLabel!
    @IBOutlet weak var continueButton: PrimaryButton!
    
    
    private var viewModel: SignInValidationViewModel! { get { return baseViewModel as? SignInValidationViewModel }}
    
    // MARK: - Lifecycle
    static func create(with viewModel: SignInValidationViewModel) -> SignInValidationViewController {
        let view = SignInValidationViewController.instantiateViewController()
        view.baseViewModel = viewModel
        
        return view
    }
    
    override func setUpUI() {
        super.setUpUI()
        titleLabel.text = viewModel.titleLabelText
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
  
    @IBAction func resendButtonPressed(_ sender: Any) {
        
        let toEmail = viewModel.viewType == .email ? true : false;
        
        showHUD()
        Api.shared.generateCode(toEmail: toEmail, completion: { result in
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
                //let vm = HomeViewModel()
                //let vc = HomeViewController.create(with: vm)
                //self.navigationController?.setViewControllers([vc], animated: true)
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

extension SignInValidationViewController: ValidatorViewDelegate {
    func validatorViewCompletedCode(view: ValidatorView ) {
   
        let text = view.value()
        continueButton.isEnabled = text.count == 4
    }
}
