//
//  ForecastResponse.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//
// This file was generated from JSON Schema using quicktype:[https://app.quicktype.io/?l=swift]

import Foundation

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - List
struct ForecastList: Codable {
    let dt: Int
    let main: ForecastMain
    let weather: [ForecastWeather]
    let clouds: ForecastClouds
    let wind: ForecastWind
    let sys: ForecastSys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct ForecastClouds: Codable {
    let all: Int
}

// MARK: - ForecastMain
struct ForecastMain: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel: Double
    let tempKf: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

//// MARK: - Rain
//struct Rain: Codable {
//    let the3H: Double
//    
//    enum CodingKeys: String, CodingKey {
//        case the3H = "3h"
//    }
//}

// MARK: - Sys
struct ForecastSys: Codable {
    let pod: String
}

// MARK: - Weather
struct ForecastWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct ForecastWind: Codable {
    let speed: Double
    let deg: Double?
    let gust: Double?
}
