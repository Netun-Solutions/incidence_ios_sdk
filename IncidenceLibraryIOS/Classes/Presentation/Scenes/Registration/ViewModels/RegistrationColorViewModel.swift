//
//  RegistrationColorViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class RegistrationColorViewModel: IABaseViewModel {
    
    private (set) var vehicleColors: [ColorType]?
    public var selectedColor: ColorType? = nil
    public var origin: RegistrationOrigin
    
    public override var navigationTitle: String? {
        get { return origin == .editVehicle ? "color".localized() : "create_account_step2".localized() }
        set { }
    }
    
    internal init(origin: RegistrationOrigin = .registration, vehicleColors: [ColorType], selectedColor: ColorType?) {
        self.origin = origin
        self.vehicleColors = vehicleColors
        self.selectedColor = selectedColor
    }
    
    lazy var helperLabelText: String = {
        return "select_vehicle_color".localized()
    }()
    
    lazy var continueButtonText: String = {
        return origin == .editVehicle ? "accept".localized() : "continuar".localized()
    }()
    
    lazy var laterButtonText: String = {
        return origin == .editVehicle ? "cancel".localized() : "add_later".localized()
    }()
}
