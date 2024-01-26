//
//  RegistrationVehicleViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import Foundation

class RegistrationVehicleViewModel: IABaseViewModel {
    
    var becomeFromAddBeacon = false
    public var fromBeacon = false

    public override var navigationTitle: String? {
        get { return "incidence_key_create_account_step2".localized() }
        set { }
    }
    
    public var origin: RegistrationOrigin
    
    internal init(origin: RegistrationOrigin = .registration) {
        self.origin = origin
    }
    
    lazy var helperLabelText: String = {
        return "incidence_key_select_type_vechicle".localized()
    }()
    
}
