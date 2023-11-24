//
//  ReportNotificationCarViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 31/5/21.
//

import Foundation


class ReportNotificationCarViewModel: IABaseViewModel {
    
    
    var vehicles: [Vehicle] = [Vehicle]()
    var isAccident:Bool = false
    var openFromNotification:Bool = false
    
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }
    
    let helperText = "ask_report_choose_vehicle".localized()
    let cancelButtonText = "cancel".localized()
}
