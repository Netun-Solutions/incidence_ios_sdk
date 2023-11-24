//
//  VehiclesDriversViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 19/5/21.
//

import Foundation

class VehiclesDriversViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "drivers".localized() }
        set { }
    }
    
    public var vehicle: Vehicle!
    
    var fieldNameTitle: String = "name".localized()
}
