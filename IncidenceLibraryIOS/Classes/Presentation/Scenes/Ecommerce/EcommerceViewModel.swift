//
//  EcommerceViewModel.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 25/10/21.
//

import Foundation


class EcommerceViewModel: IABaseViewModel {
    
    public override var navigationTitle: String? {
        get { return "buy_beacon".localized() }
        set { }
    }
    
    public var vehicle: Vehicle
    public var user: User
    
    public init(vehicle: Vehicle, user: User) {
        self.vehicle = vehicle
        self.user = user
    }
}
