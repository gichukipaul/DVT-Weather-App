//
//  WeatherServiceProtocol.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    var apiKey: String { get }
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastResponse, Error>) -> Void)
}
