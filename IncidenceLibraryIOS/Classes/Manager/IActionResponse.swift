//
//  IActionResponse.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 21/11/23.
//

import Foundation

public struct IActionResponse {
    
    let status: Bool
    let message: String?
    
    init(status:Bool) {
        self.status = status
        message = ""
    }
    
    init(status:Bool, message: String?) {
        self.status = status
        self.message = message
    }
}
