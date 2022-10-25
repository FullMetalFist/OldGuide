//
//  MapViewModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/25/22.
//

import Foundation

class MapViewModel {
    
    var exits: [Exit] = []
    
    func fetchExitLocations() {
        guard let path = Bundle.main.path(forResource: "subway", ofType: "json") else { return }
        do {
            guard let nsData = NSData(contentsOfFile: path) else { return }
            let data = Data(referencing: nsData)
            let result = try JSONDecoder().decode([Exit].self, from: data)
            exits = result
            print(exits)
        }
        catch {
            print(error)
        }
    }
}
