//
//  MapViewModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/25/22.
//

import Foundation
import Combine
import CoreLocation

enum ExitResult<Exit, Error> {
    case success([Exit])
    case error(Error)
}

class MapViewModel {
    
    var exits: [Exit] = []
    
    func fetchExitLocations(completion: (ExitResult<Exit, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "subway", ofType: "json") else { return }
        do {
            guard let nsData = NSData(contentsOfFile: path) else { return }
            let data = Data(referencing: nsData)
            let result = try JSONDecoder().decode([Exit].self, from: data)
            completion(.success(result))
        }
        catch {
            completion(.error(error))
        }
    }
    
    func passCustomMapURL() -> URL? {
        guard let styleURL = Bundle.main.url(forResource: "guideUserMap001", withExtension: "json") else { return nil }
        return styleURL
    }
}
