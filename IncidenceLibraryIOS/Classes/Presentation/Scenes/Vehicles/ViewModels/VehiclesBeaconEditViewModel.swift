//
//  VehiclesBeaconEditViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import Foundation

class VehiclesBeaconEditViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "beacon".localized() }
        set { }
    }
    
    public var device: Beacon
    
    public init(device: Beacon) {
        self.device = device
    }
    
    var fieldNameTitle: String = "name".localized()
    var saveButtonText: String = "save".localized()
    var cancelButtonText: String = "cancel".localized()
    
}

