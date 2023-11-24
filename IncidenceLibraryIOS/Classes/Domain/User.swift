//
//  User.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 04/06/2021.
//

import UIKit

public class User:Codable {
    var id: Int?
    public var externalUserId: String?
    var alias: String?
    public var name: String?
    public var phone: String?
    public var email: String?
    public var identityType: IdentityType?
    public var dni: String?
    public var birthday: String?
    public var checkTerms: Int?
    public var checkAdvertising: Int?
    
    public init(){}
}
