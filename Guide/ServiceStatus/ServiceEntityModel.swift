//
//  ServiceEntityModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 10/26/22.
//

import Foundation

struct ServiceEntityModel: Decodable {
    
    let id: String
    let alert: Alert
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case alert = "alert"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        alert = try values.decode(Alert.self, forKey: .alert)
        
    }
}

struct Alert: Decodable {
    let headerText: HeaderText
    let descriptionText: DescriptionText
    let transitRealtimeAlert: TransitRealtimeAlert
    
    private enum CodingKeys: String, CodingKey {
        case headerText = "header_text"
        case descriptionText = "description_text"
        case transitRealtimeAlert = "transit_realtime.mercury_alert"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        headerText = try values.decode(HeaderText.self, forKey: .headerText)
        descriptionText = try values.decode(DescriptionText.self, forKey: .descriptionText)
        transitRealtimeAlert = try values.decode(TransitRealtimeAlert.self, forKey: .transitRealtimeAlert)
    }
}

struct HeaderText: Decodable {
    let textLanguagePair: [[String: String]]
}

struct DescriptionText: Decodable {
    let textLanguagePair: [[String: String]]
}

struct TransitRealtimeAlert: Decodable {
    let alertType: String
    let humanReadableActivePeriod: HumanReadableActivePeriod
    
    private enum CodingKeys: String, CodingKey {
        case alertType = "alert_type"
        case humanReadableActivePeriod = "human_readable_active_period"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.alertType = try container.decode(String.self, forKey: .alertType)
        self.humanReadableActivePeriod = try container.decode(HumanReadableActivePeriod.self, forKey: .humanReadableActivePeriod)
    }
}

struct HumanReadableActivePeriod: Decodable {
    let textLanguagePair: [[String: String]]
}

struct TextLanguage: Decodable {
    let text: String
    let language: String
}
