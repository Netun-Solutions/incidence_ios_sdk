//
//  ReportAccidentViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import Foundation

class ReportAccidentViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "report_incidence".localized() }
        set { }
    }
    
    var vehicle:Vehicle?
    var openFromNotification:Bool = false

    let descriptionText: String = "ask_wounded".localized()
    let noInjuredButtonText: String = "no_only_material_wounded".localized()
    let injuredText: String = "accident_with_wounded".localized()
    let cancelButtonText: String = "cancel".localized()
}
