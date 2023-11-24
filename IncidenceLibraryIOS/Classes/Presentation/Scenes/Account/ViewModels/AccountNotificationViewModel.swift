//
//  AccountNotificationViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/6/21.
//

import Foundation

class AccountNotificationViewModel: IABaseViewModel {
    public override var navigationTitle: String? {
        get { return "notifications".localized() }
        set { }
    }
    
    var vehicleText: String = "vehicle_and_beacon".localized()
    var promotionsText: String = "promotions".localized()
    var disclaimerText: String = "notifs_beacon_description".localized()

}
