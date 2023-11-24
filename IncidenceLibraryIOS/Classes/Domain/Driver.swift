//
//  Driver.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 15/06/2021.
//

import UIKit

class Driver:Codable {
    
    var id: Int?
    var name: String?
    var type: Int? // 1 primario, 0 secundario.
    
    init()
    {
    }
    
    func isTypePrimary() -> Bool
    {
        var res = false
        if let tp = type, tp == 1 {
            res = true
        }
        
        return res
    }
}
