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
        let _ = session.dataTask(with: request) { stuff, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 200 {
                if let stuff = stuff {
                    
                    do {
                        let bunch = try JSONDecoder().decode([String: [ServiceEntityModel]].self, from: stuff)
                        print("\(bunch)")
                    }
                    catch {
                        print("\n\n\n\n")
                        print("\(error)")
                        print("\(error.localizedDescription)")
                        print("\n\n\n\n")

                    }
                        
                }
            }
            
        }
            .resume()
    }
    
    func fetchElevatorEscalatorStatus() {
        guard let eesURL = elevatorEscalatorStatusURL else { return }
        var request = URLRequest(url: eesURL)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        let _ = session.dataTask(with: request) { stuff, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                if let stuff = stuff {
                    
                    do {
                        let bunch = try JSONDecoder().decode([ElevatorEscalatorStatusModel].self, from: stuff)

                    }
                    catch {
                        print("\(error)")
                    }
                }
            }
        }
            .resume()
    }
}
