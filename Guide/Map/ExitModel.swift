//
//  ExitModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/25/22.
//

import Foundation

struct Exit: Decodable {
    let division: String
    let line: String
    let stationName: String
    let stationLatitude: Double
    let stationLongitude: Double
    let route1: String
    let route2: String
    let route3: String
    let route4: String
    let entranceType: EntranceType
    let entry: String
    let exitOnly: String
    let vending: String
    let staffing: String
    let ada: String
    let freeCrossover: String
    let northSouthStreet: String
    let eastWestStreet: String
    let corner: String
    let latitude: Double
    let longitude: Double
    
    enum EntranceType: String, Decodable {
        case stair = "Stair"
        case door = "Door"
        case easement = "Easement"
        case escalator = "Escalator"
        case elevator = "Elevator"
        case ramp = "Ramp"
    }
    
    private enum CodingKeys: String, CodingKey {
        case division = "Division"
        case line = "Line"
        case stationName = "Station_Name"
        case stationLatitude = "Station_Latitude"
        case stationLongitude = "Station_Longitude"
        case route1 = "Route_1"
        case route2 = "Route_2"
        case route3 = "Route_3"
        case route4 = "Route_4"
        case entranceType = "Entrance_Type"
        case entry = "Entry"
        case exitOnly = "Exit_Only"
        case vending = "Vending"
        case staffing = "Staffing"
        case ada = "ADA"
        case freeCrossover = "Free_Crossover"
        case northSouthStreet = "North_South_Street"
        case eastWestStreet = "East_West_Street"
        case corner = "Corner"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        division = try values.decode(String.self, forKey: .division)
        line = try values.decode(String.self, forKey: .line)
        stationName = try values.decode(String.self, forKey: .stationName)
        stationLatitude = try values.decode(Double.self, forKey: .stationLatitude)
        stationLongitude = try values.decode(Double.self, forKey: .stationLongitude)
        route1 = try values.decode(String.self, forKey: .route1)
        route2 = try values.decode(String.self, forKey: .route2)
        route3 = try values.decode(String.self, forKey: .route3)
        route4 = try values.decode(String.self, forKey: .route4)
        entranceType = try values.decode(EntranceType.self, forKey: .entranceType)
        entry = try values.decode(String.self, forKey: .entry)
        exitOnly = try values.decode(String.self, forKey: .exitOnly)
        vending = try values.decode(String.self, forKey: .vending)
        staffing = try values.decode(String.self, forKey: .staffing)
        ada = try values.decode(String.self, forKey: .ada)
        freeCrossover = try values.decode(String.self, forKey: .freeCrossover)
        northSouthStreet = try values.decode(String.self, forKey: .northSouthStreet)
        eastWestStreet = try values.decode(String.self, forKey: .eastWestStreet)
        corner = try values.decode(String.self, forKey: .corner)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
}


