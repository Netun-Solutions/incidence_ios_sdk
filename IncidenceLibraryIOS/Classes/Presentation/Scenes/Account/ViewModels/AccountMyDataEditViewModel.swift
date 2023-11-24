//
//  AccountMyDataEditViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import Foundation

class AccountMyDataEditViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "account".localized() }
        set { }
    }
    
    var fieldNameTitle: String = "name".localized()
    var fieldPhoneTitle: String = "mobile_phone".localized()
    var fieldEmailTitle: String = "email".localized()
    var fieldIDTitle: String = "nif_doc_identity".localized()
    var fieldDatebirthTitle: String = "birthday".localized()
    var saveButtonText: String = "save".localized()
    var cancelButtonText: String = "cancel".localized()
    
}
