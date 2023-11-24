//
//  IdentityType.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 05/06/2021.
//

import UIKit

public class IdentityType:Codable {
    
    public var id: Int?
    public var name: String
    
    public init(){
        self.id = nil
        self.name = ""
    }
    
    internal init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
