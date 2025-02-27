//
//  WeatherService.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    private let networkService: NetworkServiceProtocol
    var apiKey: String
    
    init(networkService: NetworkServiceProtocol = NetworkService(), apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void) {
        let url = constructURL(endpoint: "weather", latitude: latitude, longitude: longitude)
        
        networkService.requestData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastResponse, WeatherServiceError>) -> Void) {
        let url = constructURL(endpoint: "forecast", latitude: latitude, longitude: longitude)
        
        networkService.requestData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    completion(.success(forecastResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func constructURL(endpoint: String, latitude: Double, longitude: Double) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(endpoint)"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey),  // Use the API key here
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components.url else {
            // Handle invalid URL more gracefully
            return URL(string: "")!
        }
        return url
    }
}


// MARK: - Custom Error Enum
enum WeatherServiceError: Error {
    case networkError(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case invalidURL
    case unknownError

    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .invalidURL:
            return "The URL was invalid."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
