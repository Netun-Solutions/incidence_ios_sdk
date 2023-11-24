//
//  AccountActiveSessionsViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import Foundation

class AccountActiveSessionsViewModel: IABaseViewModel {
    
    var activeSessions: [Session] = [Session]()
    
    public override var navigationTitle: String? {
        get { return "active_sessions".localized() }
        set { }
    }
}
