//
//  AddBeaconToCarViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import Foundation

class AddBeaconToCarViewModel: IABaseViewModel {

    public var beacon:Beacon!
    
    public override var navigationTitle: String? {
        get { return "create_account_step3".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "select_vehicle_to_link".localized()
    }()

    var vehicles: [Vehicle?] = [Vehicle]()
}
