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
    
    public var vehicle: Vehicle?
    public var vehicleTmp: Vehicle?
    public var openFromNotification:Bool = false
    
    public init(vehicle: Vehicle?, openFromNotification:Bool) {
        self.vehicle = vehicle
        self.openFromNotification = openFromNotification
    }
    
    public init(vehicle: Vehicle?, vehicleTmp: Vehicle?, openFromNotification:Bool) {
        self.vehicle = vehicle
        self.vehicleTmp = vehicleTmp
        self.openFromNotification = openFromNotification
    }
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }

    let titleText: String = "report_ask_what".localized()
    let descriptionText: String = "report_ask_what_descrip".localized()
    let breakdownButtonText: String = "fault".localized()
    let accidentButtonText: String = "accident".localized()
    let cancelButtonText: String = "cancel".localized()
}
