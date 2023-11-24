//
//  RegistrationIDViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation

class RegistrationIDViewModel: IABaseViewModel {

    public override var navigationTitle: String? {
        get { return "create_account_step1".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "nif_title".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
}
