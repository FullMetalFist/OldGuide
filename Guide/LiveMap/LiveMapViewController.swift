//
//  LiveMapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/10/22.
//

import UIKit
import WebKit

class LiveMapViewController: UIViewController {

    lazy var siteView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let url = URL(string: Constants.Endpoint.liveSystemMapURLString) else { return }
        let request = URLRequest(url: url)
        siteView.load(request)
    }
    
    private func setupViews() {
        view.addSubview(siteView)
        siteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        siteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        siteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        siteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension LiveMapViewController: WKUIDelegate {
    
}
