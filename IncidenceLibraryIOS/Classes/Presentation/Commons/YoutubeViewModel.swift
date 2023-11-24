//
//  YoutubeViewModel.swift
//  IncidenceApp
//
//  Created by VictorM Martinez Fernandez on 13/7/22.
//

import Foundation

class YoutubeViewModel: IABaseViewModel {
    
    var code: String
    public override var navigationTitle: String? {
        get { return _navigationTitle }
        set { }
    }
    private var _navigationTitle: String?
    
    init(title: String, code: String) {
        self.code = code
        super.init()
        self._navigationTitle = title
    }
}
