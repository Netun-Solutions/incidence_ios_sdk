//
//  APIEndpoints.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 10/05/2021.
//

import Foundation
//import E510_Networking

struct APIEndpoints {
    
    static let API_BASE_URL_PRO = "https://api-pro.incidence.eu"
    static let API_BASE_URL_PRE = "https://api-pre.incidence.eu"
    static let API_BASE_URL_TEST = "https://api-test.incidence.eu"
    
    static var API_BASE_URL = API_BASE_URL_PRO
    
    
    
    /*
    
    static func basicHeaders() -> [String: String] {
        var headers:[String: String] = [:]
        
        headers["deviceId"] = UIDevice.current.identifierForVendor?.uuidString
        headers["lang"] = Locale.current.languageCode
        
        return headers
    }

    static func signIn(parameters: [String: Any?]) -> Endpoint<IResponse> {
        return Endpoint(path: "users/login",
                        method: .post,
                        headerParamaters: basicHeaders(),
                        bodyParamaters: parameters,
                        serviceType: .miniApps(token: false))
    }
    */
}
