//
//  SignInValidationViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import Foundation

class SignInValidationViewModel: IABaseViewModel {
    
    let viewType: SignInViewType
    
    internal init(viewType: SignInViewType) {
        self.viewType = viewType
    }
    
    public override var navigationTitle: String? {
        get { return viewType == .email ? "sign_in_email".localized() : "sign_in_phone".localized() }
        set { }
    }
    
    lazy var titleLabelText: String = {
        return "hola".localized()
    }()
    
    lazy var helperLabelText: String = {
        return viewType == .email ? "sms_introduce_email".localized() : "sms_introduce".localized()
    }()
    
    lazy var resendButtonText: String = {
        return "sms_resend".localized()
    }()
    
    lazy var countdownLabelText: String = {
        return "sms_caducity_time".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "sms_validate".localized()
    }()
    
}
