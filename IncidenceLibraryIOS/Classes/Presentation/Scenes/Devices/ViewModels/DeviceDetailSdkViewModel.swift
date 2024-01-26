//
//  DeviceDetailSdkViewModel.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 21/11/23.
//

import Foundation

class DeviceDetailSdkViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return (device != nil) ? device!.name : "incidence_key_beacon".localized() }
        set { }
    }
    
    public var vehicle: Vehicle
    public var user: User
    public var device: Beacon?
    var delegate: ReportTypeViewControllerDelegate
    
    public init(vehicle: Vehicle, user: User, delegate: ReportTypeViewControllerDelegate!) {
        self.vehicle = vehicle
        self.user = user
        self.delegate = delegate
    }
    
    var fieldNameTitle: String = "incidence_key_name".localized()
    var fieldModelTitle: String = "incidence_key_model".localized()
    var fieldLinkedVehicleTitle: String = "incidence_key_link_with".localized()
    var deleteButtonText: String = "incidence_key_delete_device".localized()
    var addButtonText: String = "incidence_key_link_with_vehicle".localized()
    var validateDeviceButtonText: String = "incidence_key_validate_device".localized()
}
