//
//  Policy.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 15/06/2021.
//

import UIKit

public class Policy:Codable {

    var id: Int? = nil
    public var policyNumber: String? = nil
    public var identityType: IdentityType? = nil
    public var dni: String? = nil
    public var policyStart: String? = nil
    public var policyEnd: String? = nil
    
    public init(){}
}
