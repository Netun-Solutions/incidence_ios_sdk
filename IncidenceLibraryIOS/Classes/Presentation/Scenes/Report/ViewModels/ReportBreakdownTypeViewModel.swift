//
//  ReportBreakdownTypeViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import Foundation

class ReportBreakdownTypeViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }
    
    var incidenceTypeList: [IncidenceType]
    var isChild: Bool
    var openFromNotification:Bool = false
    
    var descriptionText: String {
        get {
            return isChild ? childDescriptionText : parentDescriptionText
        }
    }
    
    var descriptionTextVoice: String {
        get {
            return isChild ? "fault_fallo_title".localizedVoice() : "ask_fault".localizedVoice()
        }
    }
    
    var childDescriptionText: String {
        get {
            let user = Core.shared.getUser()
            let name = user?.alias ?? user?.name ?? ""
            return String(format: "fault_fallo_title".localized(), name)
        }
    }
    
    let parentDescriptionText: String = "ask_fault".localized()
    //let childDescriptionText: String = "ask_valoration".localized()
    let cancelButtonText: String = "cancel".localized()
    
    var vehicle:Vehicle
    var user:User
    var delegate: ReportTypeViewControllerDelegate
    
    public init(incidenceTypeList: [IncidenceType], isChild: Bool = false, vehicle: Vehicle, user: User, delegate: ReportTypeViewControllerDelegate, openFromNotification:Bool) {
        self.incidenceTypeList = incidenceTypeList
        self.isChild = isChild
        self.vehicle = vehicle
        self.user = user
        self.delegate = delegate
        self.openFromNotification = openFromNotification
    }
}
