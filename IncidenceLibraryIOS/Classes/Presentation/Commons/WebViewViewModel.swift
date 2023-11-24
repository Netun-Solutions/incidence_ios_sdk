//
//  WebViewViewModel.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import Foundation

class WebViewViewModel: IABaseViewModel {
    
    var website: URL
    public override var navigationTitle: String? {
        get { return _navigationTitle }
        set { }
    }
    private var _navigationTitle: String?
    
    init(title: String, website: URL) {
        self.website = website
        super.init()
        self._navigationTitle = title
    }
}
