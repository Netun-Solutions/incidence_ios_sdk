//
//  IActionResponse.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 21/11/23.
//

import Foundation

public struct IActionResponse {
    
    public let status: Bool
    public let message: String?
    public let data: Any? = nil
    
    init(status:Bool) {
        self.status = status
        self.message = ""
    }
    
    init(status:Bool, message: String?) {
        self.status = status
        self.message = message
    }
}
