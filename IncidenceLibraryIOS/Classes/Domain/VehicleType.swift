//
//  VehicleType.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 14/06/2021.
//

import UIKit

public class VehicleType:Codable {
    var id: Int?
    public var name: String?
    var colors: [ColorType]?
    
    public init(){}
}
