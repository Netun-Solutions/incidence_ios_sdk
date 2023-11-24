//
//  SelectVehicleDriverTypeViewModel.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 4/2/22.
//

import Foundation

class SelectVehicleDriverTypeViewModel: IABaseViewModel {
    
    var vehicleId: String
    
    init(vehicleId: String) {
        self.vehicleId = vehicleId
    }
    public override var navigationTitle: String? {
        get { return "create_account_step2".localized() }
        set { }
    }
}
