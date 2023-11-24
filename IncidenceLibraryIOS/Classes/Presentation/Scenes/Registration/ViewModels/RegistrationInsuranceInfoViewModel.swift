//
//  RegistrationInsuranceInfoViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import Foundation

class RegistrationInsuranceInfoViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "create_account_step2".localized() }
        set { }
    }
    
    public var origin: RegistrationOrigin
    
    internal init(origin: RegistrationOrigin = .registration) {
        self.origin = origin
    }
    
    lazy var helperLabelText: String = {
        return "complete_insurance_data".localized()
    }()
    
    lazy var insuranceFieldViewText: String = {
        return "company_insurance".localized()
    }()
    
    lazy var numberFieldViewText: String = {
        return "company_insurance_number".localized()
    }()
    
    lazy var dniFieldViewText: String = {
        return "company_insurance_titular".localized()
    }()
    
    lazy var expirationFieldViewText: String = {
        return "caducity".localized()
    }()

    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
    lazy var laterButtonText: String = {
        return "add_later".localized()
    }()
}
