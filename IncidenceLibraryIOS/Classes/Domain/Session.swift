//
//  Session.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 15/06/2021.
//

import UIKit

class Session:Codable {
    var id: Int
    var manufacturer: String?
    var model: String?
    
    func getName() -> String
    {
        var res = ""
        
        if let man = manufacturer {
            res = man.lowercased() == "apple" ? "" : man
        }
        
        if (model != nil) {
            if (res.count > 0) {
                res = res + " " + model!
            }
            else {
                res = model!
            }
        }
        
        return res
    }
}
