//
//  HomeMapViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 25/5/21.
//

import Foundation

enum HomeMapType {
    case findLocation
    case incidence
}

class HomeMapViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "back".localized() }
        set { }
    }
    
    init(type: HomeMapType) {
        self.type = type
        self.vehicle = nil
    }
    
    let type: HomeMapType
    var vehicle:Vehicle?
}
