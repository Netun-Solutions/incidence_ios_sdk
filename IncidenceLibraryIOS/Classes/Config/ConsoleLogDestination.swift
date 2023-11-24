//
//  ConsoleLogDestination.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 18/8/23.
//

import Foundation

/// Basic destination for outputting messages to console.
public class ConsoleLogDestination: BaseLogDestination {
    override open func write(message: String) {
        print(message)
    }
}

