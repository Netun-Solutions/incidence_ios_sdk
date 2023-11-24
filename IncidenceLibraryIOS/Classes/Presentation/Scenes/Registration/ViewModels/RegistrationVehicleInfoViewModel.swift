//
//  RegistrationVehicleInfoViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import Foundation

class RegistrationVehicleInfoViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "create_account_step2".localized() }
        set { }
    }
    
    public var origin: RegistrationOrigin
    
    internal init(origin: RegistrationOrigin = .registration) {
        self.origin = origin
    }
    
    lazy var helperLabelText: String = {
        return "check_vehicle_data_correct".localized()
    }()
    
    lazy var inputPlatePlaceholderText: String = {
        return "matricula".localized()
    }()
    
    lazy var inputYearPlaceholderText: String = {
        return "matricula_year_optional".localized()
    }()
    
    lazy var inputBrandPlaceholderText: String = {
        return "brand".localized()
    }()
    
    lazy var inputModelPlaceholderText: String = {
        return "model".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
}
