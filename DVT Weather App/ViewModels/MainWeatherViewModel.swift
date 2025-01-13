//
//  MainWeatherViewModel.swift
//  DVT Weather App
//
//  Created by GICHUKI on 10/01/2025.
//

import Foundation
import Combine

class MainWeatherViewModel: ObservableObject {
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var errorMessage: String?
    @Published var favouriteLocations: [FavouriteLocation] = [] {
        didSet {
            saveFavourites() // Automatically save when favouriteLocations changes
        }
    }
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        loadFavourites()
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        let currentWeatherPublisher = Future<WeatherResponse, WeatherServiceError> { promise in
            self.weatherService.fetchCurrentWeather(latitude: latitude, longitude: longitude, completion: promise)
        }
        
        let forecastPublisher = Future<ForecastResponse, WeatherServiceError> { promise in
            self.weatherService.fetchForecast(latitude: latitude, longitude: longitude, completion: promise)
        }
        
        Publishers.Zip(currentWeatherPublisher, forecastPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] weather, forecast in
                self?.currentWeather = weather
                self?.forecast = forecast
                
            })
            .store(in: &cancellables)
    }
    
    var dailyForecasts: [ForecastInfo] {
        guard let forecast = forecast else { return [] }
        return Utilities.extractDailyForecast(from: forecast)
    }
    
    // MARK: Favourite implementation
   
    func addFavourite(location: FavouriteLocation) {
        // Check if the location already exists in the favouriteLocations array
        if !favouriteLocations.contains(where: { $0.id == location.id }) {
            favouriteLocations.append(location)
            saveFavourites()
        }
    }
    
       
    func removeFavourite(id: UUID) {
            favouriteLocations.removeAll { $0.id == id }
            saveFavourites()
    }
        
    private func saveFavourites() {
        if let data = try? JSONEncoder().encode(favouriteLocations) {
            UserDefaults.standard.set(data, forKey: "favourites")
        }
    }
        
    private func loadFavourites() {
        if let data = UserDefaults.standard.data(forKey: "favourites"),
            let favourites = try? JSONDecoder().decode([FavouriteLocation].self, from: data) {
            favouriteLocations = favourites
        }
    }
}
