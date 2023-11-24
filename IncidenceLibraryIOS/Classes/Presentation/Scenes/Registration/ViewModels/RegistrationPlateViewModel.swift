//
//  RegistrationPlateViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import Foundation

class RegistrationPlateViewModel: IABaseViewModel {
    
    public var origin: RegistrationOrigin
    
    internal init(origin: RegistrationOrigin = .registration) {
        self.origin = origin
    }
    
    public override var navigationTitle: String? {
        get { return "create_account_step2".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "add_matricula_title".localized()
    }()
    
    lazy var inputPlaceholderText: String = {
        return "matricula".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "continuar".localized()
    }()
    
}
