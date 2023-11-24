//
//  RegistrationValidationViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation

class RegistrationValidationViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "create_account_step1".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "sms_introduce".localized()
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
