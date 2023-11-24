//
//  ReportIncidenceSimpleViewModel.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 7/11/23.
//

import Foundation

public class ReportIncidenceSimpleViewModel: IABaseViewModel {
    
    let vehicle: Vehicle!
    let user: User!
    let incidence: Incidence!
    let createIncidence: Bool!
    
    public init(user: User!, vehicle: Vehicle!, incidence: Incidence!, createIncidence: Bool!) {
        self.vehicle = vehicle
        self.user = user
        self.incidence = incidence
        self.createIncidence = createIncidence
    }
    
    public override var navigationTitle: String? {
        get { return "devices".localized() }
        set { }
    }
}
