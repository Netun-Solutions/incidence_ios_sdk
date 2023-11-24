//
//  RegistrationEmailViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation

class RegistrationEmailViewModel: IABaseViewModel {

    public override var navigationTitle: String? {
        get { return "create_account_step1".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "email_title_signup".localized()
    }()
    
    lazy var placeholderInputViewText: String = {
        return "email".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
}
