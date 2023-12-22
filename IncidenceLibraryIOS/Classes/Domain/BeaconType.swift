//
//  BeaconType.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 14/06/2021.
//

import UIKit

class BeaconType:Codable {
    var id: Int?
    var name: String
    var uuid: String?
    var imageBeacon: String?
    var imageBeaconScreen1: String?
    var imageBeaconScreen2: String?
    var imageBeaconScreen3: String?
    var textBeaconScreen1: String?
    var textBeaconScreen2: String?
    var textBeaconScreen3: String?
    
    init()
    {
        self.name = "";
    }
}
