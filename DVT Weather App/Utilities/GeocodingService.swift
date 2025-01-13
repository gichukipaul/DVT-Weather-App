//
//  GeocodingService.swift
//  DVT Weather App
//
//  Created by GICHUKI on 13/01/2025.
//

import Foundation
import CoreLocation

class GeocodingService {
    private let geocoder = CLGeocoder()
    
    func getCoordinates(for address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            } else {
                completion(.failure(NSError(domain: "GeocodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No coordinates found."])))
            }
        }
    }
}
