//
//  ReportAccidentViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import Foundation

class ReportAccidentViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "incidence_key_report_incidence".localized() }
        set { }
    }
    
    init(vehicle: Vehicle, user: User, delegate: ReportTypeViewControllerDelegate, openFromNotification:Bool = false) {
        self.vehicle = vehicle
        self.user = user
        self.delegate = delegate
        self.openFromNotification = openFromNotification
    }
    
    var vehicle:Vehicle
    var user:User
    var delegate: ReportTypeViewControllerDelegate
    var openFromNotification:Bool

    let descriptionText: String = "incidence_key_ask_wounded".localized()
    let noInjuredButtonText: String = "incidence_key_no_only_material_wounded".localized()
    let injuredText: String = "incidence_key_accident_with_wounded".localized()
    let cancelButtonText: String = "incidence_key_cancel".localized()
}
