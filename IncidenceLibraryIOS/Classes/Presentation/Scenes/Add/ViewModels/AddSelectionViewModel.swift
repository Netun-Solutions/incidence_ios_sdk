//
//  AddSelectionViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 10/5/21.
//

import Foundation

class AddSelectionViewModel: IABaseViewModel {

    public override var navigationTitle: String? {
        get { return "add".localized() }
        set { }
    }
    
    lazy var helperLabelText: String = {
        return "select_vehicle_or_beacon".localized()
    }()
   
}
