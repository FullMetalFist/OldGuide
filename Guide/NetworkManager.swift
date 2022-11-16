//
//  NetworkManager.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/25/22.
//

import Foundation
import Network

enum StatusResult {
    case success([ElevatorEscalatorStatusModel])
    case failure(Error)
}

class NetworkManager {
    private let serviceStatusURL: URL? = URL(string: Constants.Endpoint.serviceStatusURLString)
    private let elevatorEscalatorStatusURL: URL? = URL(string: Constants.Endpoint.elevatorEscalatorStatusURLString)
    private let session: URLSession = URLSession.shared
    private let apiKey: String = Constants.mtaAPIKey
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Internet Connection Monitor")
    
    static let shared = NetworkManager()
    private init() { }
    
    func checkService() {
        
        monitor.pathUpdateHandler = { pathHandler in
            if pathHandler.status == .satisfied {
                print("ok")
            }
            else {
                print("no connection")
            }
        }
        monitor.start(queue: queue)
    }
    
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
    
    func fetchElevatorEscalatorStatus(_ completion: @escaping (StatusResult) -> ()) {
        guard let eesURL = elevatorEscalatorStatusURL else { return }
        var request = URLRequest(url: eesURL)
        request.setValue(apiKey, forHTTPHeaderField: Constants.apiHeaderKeyString)
        let _ = session.dataTask(with: request) { stuff, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                if let stuff = stuff {
                    
                    do {
                        let list = try JSONDecoder().decode([ElevatorEscalatorStatusModel].self, from: stuff)
                        completion(.success(list))
                    }
                    catch {
                        print("\(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
            .resume()
    }
    
    // create enum to map network call to specific line
    // build generic network around fetching data and drop in specific feed from enum
    // display cells
    
    func fetchPathFromURL(with stringURL: String) {
        guard let url = URL(string: stringURL + "&key=\(Constants.googleMapsAPIKey)") else { return }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: Constants.apiHeaderKeyString)
        let _ = session.dataTask(with: request) { path, response, error in
            print("\n\n\n\n")
            print(path)
            print(response)
            print(error)
            print("\n\n\n\n")
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                if let path = path {
                    do {
                        print(path)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
    }
}
