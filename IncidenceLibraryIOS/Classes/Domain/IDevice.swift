//
//  IDevice.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 04/06/2021.
//

import UIKit

class IDevice: Codable {
    var id: Int?
    var uuid: String?
    var token: String?
    var platform: String?
    var version: String?
    var manufacturer: String?
    var model: String?
    var appVersion: String?
    var appVersionNumber: String?
}
