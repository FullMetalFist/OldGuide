//
//  RouteModel.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/23/22.
//

import Foundation

struct OverviewPolyline: Decodable {
    let points: String
}

struct Route: Decodable {
    let summary: String
    let overviewPolyline: OverviewPolyline
    
    private enum CodingKeys: String, CodingKey {
        case summary = "summary"
        case overviewPolyline = "overview_polyline"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        summary = try values.decode(String.self, forKey: .summary)
        overviewPolyline = try values.decode(OverviewPolyline.self, forKey: .overviewPolyline)
    }
    
    init?(from dictionary: Dictionary<String, AnyObject>?) {
        print(dictionary)
        guard let route = dictionary?["routes"]?.firstObject as? Dictionary<String, AnyObject>,
              let summary = route["summary"] as? String,
              let polyline = route["overview_polyline"] as? Dictionary<String, String>,
              let points = polyline["points"] else { return nil }
        self.summary = summary
        let newPolyline = OverviewPolyline(points: points)
        self.overviewPolyline = newPolyline
    }
}
