//
//  AccountViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 4/5/21.
//

import Foundation

public class AccountViewModel: IABaseViewModel {
    
    public override init() {}
    
    public override var navigationTitle: String? {
        get { return "account".localized() }
        set { }
    }
}
