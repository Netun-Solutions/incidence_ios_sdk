//
//  IncidencesDetailViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 12/5/21.
//

import Foundation

class IncidencesDetailViewModel: IABaseViewModel {
    
    var vehicle: Vehicle
    var incidence: Incidence
    
    init(vehicle: Vehicle, incidence: Incidence) {
        self.vehicle = vehicle
        self.incidence = incidence
    }
    
    public override var navigationTitle: String? {
        get {
            
            if let city = incidence.city {
                
                return incidence.getTitle() + " " + "incidence_key_incidence_in".localized() + " " + city
            }
            
            return incidence.getTitle()
            
        }
        set { }
    }
}
