//
//  VehiclesMenuViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import Foundation

class VehiclesMenuViewModel: IABaseViewModel {
    
    var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    public override var navigationTitle: String? {
        get { return vehicle.getName() }
        set { }
    }
}
