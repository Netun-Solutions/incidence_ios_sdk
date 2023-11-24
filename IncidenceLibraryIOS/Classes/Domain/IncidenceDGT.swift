//
//  IncidenceDGT.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 27/10/22.
//

import UIKit
import Foundation

class IncidenceDGT: Codable {
    
    var id: Int?
    var date, hour: String?
    var lat, lon: Double?
    
    init()
    {
        self.id = nil
        self.date = nil
        self.hour = nil
        self.lat = nil
        self.lon = nil
    }
}

