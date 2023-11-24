//
//  DeviceListViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 11/5/21.
//

import Foundation

public class DeviceListViewModel: IABaseViewModel {
    
    var devices: [Beacon?] = [Beacon]()
    
    public override init() {}
    
    public override var navigationTitle: String? {
        get { return "devices".localized() }
        set { }
    }
}
