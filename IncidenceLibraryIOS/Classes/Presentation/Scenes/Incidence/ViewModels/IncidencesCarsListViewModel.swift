//
//  IncidencesCarsListViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 12/5/21.
//

import Foundation

class IncidencesCarsListViewModel: IABaseViewModel {
    
    var vehicles: [Vehicle?] = [Vehicle]()
    
    public override var navigationTitle: String? {
        get { return "incidence_key_incidences".localized() }
        set { }
    }
}
