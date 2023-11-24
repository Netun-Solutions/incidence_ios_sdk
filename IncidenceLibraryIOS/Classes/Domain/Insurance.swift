//
//  Insurance.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 30/4/21.
//

import UIKit

class Insurance:Codable {
    
    var id: Int? = nil
    var name: String = ""
    var relation: Int? = nil
    var phone: String? = nil
    var internationaPhone: String? = nil
    var image: String? = nil
    var svg: String? = nil
    
    var textIncidence: String? = nil
    
    init(){}
}
