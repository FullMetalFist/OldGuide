//
//  LiveMapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/10/22.
//

import UIKit
import WebKit

class LiveMapViewController: UIViewController {

    let siteView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    
    convenience init(lat: Double?, lng: Double?) {
        self.init()
        self.latitude = lat ?? 0.0
        self.longitude = lng ?? 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let urlString = Constants.Endpoint().liveFeedLocation(latitude: latitude, longitude: longitude)
        guard let url = URL(string: urlString) else { return }
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
