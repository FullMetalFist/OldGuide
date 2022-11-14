//
//  OutageViewModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/12/22.
//

import Foundation

class OutageViewModel: ObservableObject {
    
    private let networkManager = NetworkManager.shared
    
    func fetchADAStatus(completion: @escaping (StatusResult) -> ()) {
        networkManager.fetchElevatorEscalatorStatus { result in
            switch result {
            case .success(let outageList):
                completion(.success(outageList))
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
}
