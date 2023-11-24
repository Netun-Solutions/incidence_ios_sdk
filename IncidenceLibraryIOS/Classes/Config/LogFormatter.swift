//
//  LogFormatter.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 18/8/23.
//

public protocol LogFormatter {
    func format(logDetails: LogDetails, message: String) -> String
}

