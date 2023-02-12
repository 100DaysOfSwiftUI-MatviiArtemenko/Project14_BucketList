//
//  Location.swift
//  Project14_BucketList
//
//  Created by admin on 11.09.2022.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Equatable, Codable {
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
