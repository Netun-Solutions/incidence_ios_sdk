//
//  DeviceDetailSdkViewModel.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 21/11/23.
//

import Foundation

class DeviceDetailSdkViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "beacon".localized() }
        set { }
    }
    
    public var vehicle: Vehicle
    public var user: User
    
    public init(vehicle: Vehicle, user: User) {
        self.vehicle = vehicle
        self.user = user
    }
    
    var fieldNameTitle: String = "name".localized()
    var fieldModelTitle: String = "model".localized()
    var fieldLinkedVehicleTitle: String = "link_with".localized()
    var deleteButtonText: String = "delete_device".localized()
    var addButtonText: String = "link_with_vehicle".localized()
    var validateDeviceButtonText: String = "validate_device".localized()
}
