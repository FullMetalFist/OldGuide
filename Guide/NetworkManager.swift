//
//  NetworkManager.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/25/22.
//

import Foundation

class NetworkManager {
    private let serviceStatusURL: URL? = URL(string: Constants.serviceStatusURLString)
    private let elevatorEscalatorStatusURL: URL? = URL(string: Constants.elevatorEscalatorStatusURLString)
    private let session: URLSession = URLSession.shared
    private let apiKey: String = Constants.mtaAPIKey
    
    func fetchServiceStatus() {
        guard let ssURL = serviceStatusURL else { return }
        var request = URLRequest(url: ssURL)
        request.setValue(apiKey, forHTTPHeaderField: Constants.apiHeaderKeyString)
        let task = session.dataTask(with: request) { stuff, response, error in
            print("\(String(describing: stuff))")
            print("\(String(describing: response))")
            print("\(String(describing: error))")
        }
            .resume()
        // create task
        // combine?
        // send
    }
    
    func fetchElevatorEscalatorStatus() {
        guard let eesURL = elevatorEscalatorStatusURL else { return }
        var request = URLRequest(url: eesURL)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        let task = session.dataTask(with: request) { stuff, response, error in
            print("\(String(describing: stuff))")
            print("\(String(describing: response))")
            print("\(String(describing: error))")
        }
            .resume()
    }
}
