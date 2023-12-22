//
//  AppConfig.swift
//  Alamofire
//
//  Created by VictorM Martinez Fernandez on 1/12/23.
//

import Foundation

class AppConfig: Codable {
    
    var background_color: String?
    var letter_color: String?
    var error_letter_color: String?
    var button_color: String?
    var button_letter_color: String?
    var support_background_color: String?
    var support_letter_color: String?
    
    public init() {}
}
