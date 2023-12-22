//
//  ReportInstructionsViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import UIKit

class ReportInstructionsViewModel: IABaseViewModel {
    
    var vehicle:Vehicle
    var user:User
    var delegate: ReportTypeViewControllerDelegate
    var incidenceTypeId:Int?
    var openFromNotification:Bool = false
    
    init(vehicle: Vehicle, user: User, delegate: ReportTypeViewControllerDelegate, incidenceTypeId:Int?, openFromNotification:Bool) {
        self.vehicle = vehicle
        self.user = user
        self.delegate = delegate
        self.incidenceTypeId = incidenceTypeId
        self.openFromNotification = openFromNotification
    }
    
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }

    let descriptionText: String = "calling_grua_tip".localized()
    
    let balizaImage = UIImage.app( "Type=Yes")?.withRenderingMode(.alwaysTemplate)
    let balizaText = "incidence_tip_beacon".localized()
    
    let lightImage = UIImage.app( "Light")?.withRenderingMode(.alwaysTemplate)
    let lightText = "incidence_tip_lights".localized()
    
    let chalecoImage = UIImage.app( "Chaleco")?.withRenderingMode(.alwaysTemplate)
    let chalecoText = "incidence_tip_vest".localized()
    
    let outImage = UIImage.app( "Property")?.withRenderingMode(.alwaysTemplate)
    let outText = "incidence_tip_exit_car".localized()
    
    let acceptButtonText: String = "accept".localized()
    let cancelButtonText: String = "cancel".localized()
    
    
}
