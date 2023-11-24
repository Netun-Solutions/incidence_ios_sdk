//
//  ReportAssesmentViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 2/6/21.
//

import Foundation

class ReportAssesmentViewModel: IABaseViewModel {
    
    var incidence: Incidence?
    
    init(incidence: Incidence?) {
        self.incidence = incidence
    }
    
    public override var navigationTitle: String? {
        get { return "service_valoration".localized() }
        set { }
    }

    let descriptionText: String = "ask_valoration".localized()
    let continueText: String = "continuar".localized()
    let laterText: String = "valorate_later".localized()
}
