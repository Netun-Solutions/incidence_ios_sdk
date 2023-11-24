//
//  VehiclesListViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import Foundation

class VehiclesListViewModel: IABaseViewModel {

    var vehicles = [Vehicle]()
        
    public override var navigationTitle: String? {
        get { return "vehicles".localized() }
        set { }
    }
}
