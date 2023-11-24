//
//  ReportAssesmentBadFeedbackViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 3/6/21.
//

import Foundation

class ReportAssesmentBadFeedbackViewModel: IABaseViewModel {
    
    var incidence: Incidence?
    var answers: [Answer]
    
    var responseAnswers: [Int] = [Int]()

    init(incidence: Incidence?, answers:[Answer]) {
        self.incidence = incidence
        self.answers = answers
    }
    
    public override var navigationTitle: String? {
        get { return "service_valoration".localized() }
        set { }
    }

    let descriptionText: String = "ask_valoration_why_bad".localized()
    let technicalText: String = "valoration_bad_spec_one".localized()
    let appText: String = "valoration_bad_spec_two".localized()
    let waitingText: String = "valoration_bad_spec_three".localized()
    let otherText: String = "valoration_bad_spec_other".localized()
    let otherTitleText: String = "specify_reason".localized()
    let otherPlaceholderText: String = "write_here".localized()
    let continueText: String = "continuar".localized()
    let laterText: String = "valorate_later".localized()
}

