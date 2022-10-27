//
//  ElevatorEscalatorStatusModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/26/22.
//

import Foundation

struct ElevatorEscalatorStatusModel: Decodable {
    /*
     "station" : "Cortlandt St",
       "borough" : "MN",
       "trainno" : "1",
       "equipment" : "EL736",
       "equipmenttype" : "EL",
       "serving" : "Greenwich Street (near southwest corner of Greenwich Street and Vesey Street) to downtown 1 platform and access to uptown 1 service",
       "ADA" : "Y",
       "outagedate" : "09/17/2018 10:57:00 AM",
       "estimatedreturntoservice" : "02/28/2023 09:00:00 AM",
       "reason" : "Station is Under Rehabilitation",
       "isupcomingoutage" : "N",
       "ismaintenanceoutage" : "N"
     */
    
    enum ElevatorEscalatorType: String, Decodable {
        case elevator = "EL"
        case escalator = "ES"
    }
    
    let station: String
    let borough: String
    let train: String
    let type: ElevatorEscalatorType
    let serving: String
    let ada: String
    let outageDate: String
    let estimatedReturnToService: String
    let reason: String
    
    private enum CodingKeys: String, CodingKey {
        case station
        case borough
        case train = "trainno"
        case type = "equipmenttype"
        case serving
        case ada = "ADA"
        case outageDate = "outagedate"
        case estimatedReturnToService = "estimatedreturntoservice"
        case reason
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        station = try values.decode(String.self, forKey: .station)
        borough = try values.decode(String.self, forKey: .borough)
        train = try values.decode(String.self, forKey: .train)
        type = try values.decode(ElevatorEscalatorType.self, forKey: .type)
        serving = try values.decode(String.self, forKey: .serving)
        ada = try values.decode(String.self, forKey: .ada)
        outageDate = try values.decode(String.self, forKey: .outageDate)
        estimatedReturnToService = try values.decode(String.self, forKey: .estimatedReturnToService)
        reason = try values.decode(String.self, forKey: .reason)
    }
}
