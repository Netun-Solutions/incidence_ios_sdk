//
//  INotification.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 21/06/2021.
//

import UIKit

class INotification:Codable
{
    var id: Int
    var title: String?
    var text: String?
    var status: Int?
    var theme: String?
    var themeStatus: Int?
    var dateCreated: String?
    var action: String?
    
    var vehicleId: Int?
    var policyId: Int?
    var incidenceId: Int?
    
    //para validar conductores
    var userId: Int?
    var driverType: Int?
    var driverName: String?
}
