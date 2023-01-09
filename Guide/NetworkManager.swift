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

enum RouteResult {
    case success(Route)
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
                    }
                    catch {
                        print("\(error)")
                        print("\(error.localizedDescription)")

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
    
    func fetchPathFromURL(origin originCoordinates: String, destination destinationCoordinates: String, completion: @escaping (RouteResult) -> ()) {
        guard let url = URL(string: "\(Constants.Endpoint.directionsAPIURLString)?origin=" + originCoordinates + "&destination=" + destinationCoordinates + "&mode=walking" + "&key=\(Constants.googleMapsDirectionsAPIKeyMain)") else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                    guard let dictPath = Route(from: json) else { return }
                    completion(.success(dictPath))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
