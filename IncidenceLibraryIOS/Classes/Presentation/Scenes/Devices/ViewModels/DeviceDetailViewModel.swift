//
//  DeviceDetailViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import Foundation

class DeviceDetailViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return useName ? device.name : "beacon".localized() }
        set { }
    }
    
    public var device: Beacon
    var useName: Bool
    
    public init(device: Beacon, useName: Bool) {
        self.device = device
        self.useName = useName
    }
    
    var fieldNameTitle: String = "incidence_key_name".localized()
    var fieldModelTitle: String = "incidence_key_model".localized()
    var fieldLinkedVehicleTitle: String = "incidence_key_link_with".localized()
    var deleteButtonText: String = "incidence_key_delete_device".localized()
    var addButtonText: String = "incidence_key_link_with_vehicle".localized()
    var validateDeviceButtonText: String = "incidence_key_validate_device".localized()
    
}

