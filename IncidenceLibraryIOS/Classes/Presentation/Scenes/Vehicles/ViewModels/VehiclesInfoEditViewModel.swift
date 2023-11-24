//
//  VehiclesInfoEditViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import Foundation

class VehiclesInfoEditViewModel: IABaseViewModel {
    
    var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    public override var navigationTitle: String? {
        get { return "vehicle_data".localized() }
        set { }
    }
    
    lazy var plateFieldViewTitle: String = {
       return "matricula".localized()
    }()
    lazy var yearFieldViewTitle: String = {
        return "matricula_year".localized()
    }()
    lazy var brandFieldViewTitle: String = {
        return "brand".localized()
    }()
    lazy var modelFieldViewTitle: String = {
        return "model".localized()
    }()
    lazy var colorFieldViewTitle: String = {
        return "color".localized()
    }()
    var saveButtonText: String = "save".localized()
    var cancelButtonText: String = "cancel".localized()
}
