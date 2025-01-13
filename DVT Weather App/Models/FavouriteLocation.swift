//
//  FavouriteLocation.swift
//  DVT Weather App
//
//  Created by GICHUKI on 13/01/2025.
//

import Foundation

struct FavouriteLocation: Identifiable, Codable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
