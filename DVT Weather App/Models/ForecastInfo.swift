//
//  ForecastInfo.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//

import Foundation
import UIKit

// To retrive specific data from the ForecastResponse object in a clean manner
struct ForecastInfo {
    let forecastDate: String
    let dayOfWeek: String
    let time: String
    let weather: String
    let temp: String
    let weatherIcon: UIImage
}
