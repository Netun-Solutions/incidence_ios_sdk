//
//  RegistrationNameViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/4/21.
//

import Foundation

class RegistrationNameViewModel: IABaseViewModel {

    public override var navigationTitle: String? {
        get { return "create_account_step1".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "name_surname_title".localized()
    }()
    
    lazy var placeholderInputViewText: String = {
        return "name_surname".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
}
