//
//  IResponse+Decodable.swift
//  IncidenceApp
//
//  Created by Xavi Nuño on 10/05/2021.
//

import Foundation

extension IResponse {
    private enum CodingKeys: String, CodingKey {
        case json = ""
        case status = "status"
        case action = "action"
        case message = "message"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.json = [:]
        self.status = try container.decode(String.self, forKey: .status)
        self.action = try container.decode(String.self, forKey: .action)
        self.message = try container.decode(String.self, forKey: .message)
    }
}
