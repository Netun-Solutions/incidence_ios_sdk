//
//  RegistrationSuccessViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import Foundation

class RegistrationSuccessViewModel: IABaseViewModel {
    
    lazy var titleLabelText: String = {
        return "success_create_your_account".localized()
    }()
    
    lazy var personalDataLabelText: String = {
        return "create_account_step1".localized()
    }()
    
    lazy var carAndInsuranceLabelText: String = {
        return "create_account_step2".localized()
    }()
    
    lazy var syncLabelText: String = {
        return "create_account_step3".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "go_home".localized()
    }()
}
