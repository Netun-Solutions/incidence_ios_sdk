//
//  VehiclesBeaconViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import Foundation

class VehiclesBeaconViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "beacon".localized() }
        set { }
    }
    
    public var vehicle: Vehicle?
    
    public init(vehicle: Vehicle?) {
        self.vehicle = vehicle
    }
    
    var fieldNameTitle: String = "name".localized()
    var fieldModelTitle: String = "model".localized()
    var deleteButtonText: String = "unlink".localized()
}
