//
//  ReportTypeViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import Foundation

enum ReportType {
    case breakdown
    case accident
}

public class ReportTypeViewModel: IABaseViewModel {
    
    public var vehicle: Vehicle
    public var vehicleTmp: Vehicle?
    public var user: User
    public var delegate: ReportTypeViewControllerDelegate
    public var flowComplete:Bool = true
    public var openFromNotification:Bool = false
    
    public init(vehicle: Vehicle, user: User, delegate: ReportTypeViewControllerDelegate, openFromNotification:Bool, flowComplete:Bool ) {
        self.vehicle = vehicle
        self.user = user
        self.delegate = delegate
        self.openFromNotification = openFromNotification
        self.flowComplete = flowComplete
    }
    
    public init(vehicle: Vehicle, vehicleTmp: Vehicle?, user: User, delegate: ReportTypeViewControllerDelegate, openFromNotification:Bool, flowComplete:Bool ) {
        self.vehicle = vehicle
        self.vehicleTmp = vehicleTmp
        self.user = user
        self.delegate = delegate
        self.openFromNotification = openFromNotification
        self.flowComplete = flowComplete
    }
    public override var navigationTitle: String? {
        get { return "incidence_key_report_incidence".localized() }
        set { }
    }

    let titleText: String = "incidence_key_report_ask_what".localized()
    let titleText2: String = "incidence_key_report_ask_what2".localized()
    let descriptionText: String = "incidence_key_report_ask_what_descrip".localized()
    let breakdownButtonText: String = "incidence_key_fault".localized()
    let accidentButtonText: String = "incidence_key_accident".localized()
    let cancelButtonText: String = "incidence_key_cancel".localized()
}
