//
//  RegistrationSuccessBeaconViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import Foundation

class RegistrationSuccessBeaconViewModel: IABaseViewModel {
    
    public var origin: RegistrationOrigin
    public var isIoT = false
    
    internal init(origin: RegistrationOrigin = .registration, isIoT:Bool = false) {
        self.origin = origin
        self.isIoT = isIoT
    }
    
    public override var navigationTitle: String? {
        get { return "create_account_step3".localized() }
        set { }
    }
    
    lazy var titleLabelText: String = {
        return "beacon_sync_success".localized()
    }()
    
    lazy var subtitleLabelText: String = {
        return "beacon_sync_success_desc".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "finish".localized()
    }()
    
}
