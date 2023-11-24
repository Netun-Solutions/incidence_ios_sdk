//
//  RegistrationTermsViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 26/4/21.
//

import Foundation

class RegistrationTermsViewModel: IABaseViewModel {

    var onlyRead = false
    
    public override var navigationTitle: String? {
        get { return "privacy".localized() }
        set { }
    }
    
    lazy var contentText: String = {
        return "terms_description".localized()
    }()
    
    lazy var firstCheckboxText: String = {
        return "terms_check1".localized()
    }()
    
    lazy var sendCheckboxText: String = {
        return "terms_check2".localized()
    }()
    
    lazy var continueButtonText: String = {
        return "acepto".localized()
    }()
    
}
