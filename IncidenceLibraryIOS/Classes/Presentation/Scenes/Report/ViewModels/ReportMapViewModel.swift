//
//  ReportMapViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import Foundation

class ReportMapViewModel: IABaseViewModel {
    
    var vehicle: Vehicle?
    var incidence: Incidence?
    
    init(vehicle: Vehicle?, incidence: Incidence?) {
        self.vehicle = vehicle
        self.incidence = incidence
    }
    
    
    public override var navigationTitle: String? {
        get { return "incidence_key_back".localized() }
        set { }
    }
}
