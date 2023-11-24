//
//  WebViewViewController.swift
//  IncidenceApp
//
//  Created by Carles Garcia Puigardeu on 5/5/21.
//

import UIKit
import WebKit

class WebViewViewController: IABaseViewController {

    private var viewModel: WebViewViewModel! { get { return baseViewModel as? WebViewViewModel }}
    
    init(viewModel: WebViewViewModel) {
        super.init(nibName: nil, bundle: nil)
        baseViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var webView: WKWebView = {
        let web = WKWebView.init(frame: UIScreen.main.bounds)
        let url = viewModel.website
        let request = URLRequest.init(url: url)
        web.load(request)
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        AppNavigation.setupNavigationApperance(navigationController!, with: .regular)
        self.loadWebsite()
        view.backgroundColor = UIColor.app(.incidence100)
    }
    
    func loadWebsite() {
        view.addSubview(self.webView)
    }

}
