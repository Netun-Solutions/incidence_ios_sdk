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
    public var beaconTypeId: Int
    var delegate: ReportTypeViewControllerDelegate
    
    internal init(origin: RegistrationOrigin = .registration, isIoT:Bool = false, beaconTypeId:Int, delegate: ReportTypeViewControllerDelegate!) {
        self.origin = origin
        self.isIoT = isIoT
        self.beaconTypeId = beaconTypeId
        self.delegate = delegate
    }
    
    public override var navigationTitle: String? {
        get { return "incidence_key_create_account_step3".localized() }
        set { }
    }
    
    lazy var titleLabelText: String = {
        return "incidence_key_beacon_sync_success".localized()
    }()
    
    lazy var subtitleLabelText: String = {
        return "incidence_key_beacon_sync_success_desc".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "incidence_key_finish".localized()
    }()
    
}
