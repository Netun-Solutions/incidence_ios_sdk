//
//  IncidenceMapViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 9/6/21.
//

// import Mapbox
import CoreLocation

class IncidenceMapViewModel: IABaseViewModel {
    
    var destination: CLLocationCoordinate2D
    var origin: CLLocationCoordinate2D
    
    init(destination: CLLocationCoordinate2D, origin: CLLocationCoordinate2D) {
        self.destination = destination
        self.origin = origin
    }
    
    public override var navigationTitle: String? {
        get { return "back".localized() }
        set { }
    }
}
