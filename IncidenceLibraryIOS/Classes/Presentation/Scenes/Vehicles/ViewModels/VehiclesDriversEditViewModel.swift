//
//  VehiclesDriversEditViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import Foundation

class VehiclesDriversEditViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "drivers".localized() }
        set { }
    }
    
    public var driver: Driver!
    public var vehicle: Vehicle!
}
