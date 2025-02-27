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
    
    @Published var currentWeather: WeatherResponse? {
        didSet {
            updateCurrentFavouriteLocation()
        }
    }
    @Published var forecast: ForecastResponse?
    @Published var errorMessage: String?
    @Published var favouriteLocations: [FavouriteLocation] = [] {
        didSet {
            saveFavourites() // Automatically save when favouriteLocations changes
        }
    }
    
    @Published var isCurrentLocationFavourite: Bool = false

    private var currentFavouriteLocation: FavouriteLocation?
    
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
    
    func fetchWeatherForLocation(_ location: String) {
        let geocodingService = GeocodingService()
        geocodingService.getCoordinates(for: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinates):
                    print("Coordinates for \(location): \(coordinates.latitude), \(coordinates.longitude)")
                    self?.fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch location: \(error.localizedDescription)"
                }
            }
        }
    }
    
    var dailyForecasts: [ForecastInfo] {
        guard let forecast = forecast else { return [] }
        return Utilities.extractDailyForecast(from: forecast)
    }
    
    // MARK: Favourite implementation
    
    func toggleFavourite() {
        guard let location = currentFavouriteLocation else { return }
        
        if isCurrentLocationFavourite {
            removeFavourite(id: location.id)
        } else {
            addFavourite(location: location)
        }
        
        isCurrentLocationFavourite.toggle()
    }
    
    private func updateCurrentFavouriteLocation() {
        guard let currentWeather = currentWeather else {
            currentFavouriteLocation = nil
            isCurrentLocationFavourite = false
            return
        }
        
        let location = FavouriteLocation(
            name: currentWeather.name ?? "Unknown",
            latitude: currentWeather.coord.lat,
            longitude: currentWeather.coord.lon
        )
        
        currentFavouriteLocation = location
        isCurrentLocationFavourite = favouriteLocations.contains(where: { $0.id == location.id })
    }
        
    private func addFavourite(location: FavouriteLocation) {
        if !favouriteLocations.contains(where: { $0.id == location.id }) {
            favouriteLocations.append(location)
        }
    }
    
    func removeFavourite(id: UUID) {
        favouriteLocations.removeAll { $0.id == id }
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
