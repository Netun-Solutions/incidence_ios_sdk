//
//  VehiclesInsuranceViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 18/5/21.
//

import Foundation

class VehiclesInsuranceViewModel: IABaseViewModel {
    
    var vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }
    public override var navigationTitle: String? {
        get { return "insurance_data".localized() }
        set { }
    }

    lazy var insuranceFieldViewTitle: String = {
       return "insurance".localized()
    }()
    lazy var idInsuranceFieldViewTitle: String = {
        return "company_insurance_number".localized()
    }()
    lazy var idOwnerFieldViewTitle: String = {
        return "company_insurance_titular".localized()
    }()
    lazy var expirationFieldViewTitle: String = {
        return "company_insurance_caducity".localized()
    }()

}
