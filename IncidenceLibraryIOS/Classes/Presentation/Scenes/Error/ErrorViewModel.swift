//
//  ErrorViewModel.swift
//  IncidenceLibraryIOS
//
//  Created by VictorM Martinez Fernandez on 28/8/23.
//

import Foundation

public class ErrorViewModel: IABaseViewModel {
    
    var error: String
    
    public init(error: String) {
        self.error = error
    }
    
    public override var navigationTitle: String? {
        get { return "incidence_key_error".localized() }
        set { }
    }
}
