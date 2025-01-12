//
//  LocationManager.swift
//  DVT Weather App
//
//  Created by GICHUKI on 10/01/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    var didFetchLocation = false // Flag to ensure one-time location fetch, since we dont need contant location updates.
    var onError: ((Error) -> Void)? // Error callback
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // Handle changes in location authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted.")
            startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied. Please enable it in Settins")
        case .notDetermined:
            print("Location access not determined. Please check in Settings")
        @unknown default:
            print("Unknown location status.")
        }
    }
    
    // Receive updated locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !didFetchLocation else { return }
        
        didFetchLocation = true // Ensure this block runs only once
        onLocationUpdate?(location) // Pass the location to the callback
        locationManager.stopUpdatingLocation() // Stop location updates
    }
    
    // Handle location fetch errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        onError?(error)
        locationManager.stopUpdatingLocation() // Stop location updates on error
    }
}

