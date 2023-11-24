//
//  IncidenceType.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 14/06/2021.
//

import UIKit

public class IncidenceType:Codable {
    var id: Int?
    var parent: Int?
    var name: String
    public var externalId: String?
    
    public init() {
        name = ""
    }
}
