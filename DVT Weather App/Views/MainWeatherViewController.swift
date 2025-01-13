//
//  MainWeatherViewController.swift
//  DVT Weather App
//
//  Created by GICHUKI on 10/01/2025.
//

import UIKit
import SwiftUI
import Combine

class MainWeatherViewController: UIViewController {
    // MARK: - VM and Dependencies
    private let viewModel: MainWeatherViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let locationManager = LocationManager()
    private var isFavorite = false // To track whether the current location is favourited
    
    // MARK: - UI Elements
    private let backgroundImageView = UIImageView()
    private let temperatureStackView = UIStackView()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let separatorView = UIView()
    
    private let horizontalStackView = UIStackView()
    private let minStackView = UIStackView()
    private let currentStackView = UIStackView()
    private let maxStackView = UIStackView()
    private let minLabel = UILabel()
    private let minDescriptionLabel = UILabel()
    private let currentLabel = UILabel()
    private let currentDescriptionLabel = UILabel()
    private let maxLabel = UILabel()
    private let maxDescriptionLabel = UILabel()
    
    private let navigateToFavouritesButton = UIButton(type: .system)
    private let searchLocationButton = UIButton(type: .system)
    private let favouriteButton = UIButton()
    
    private let forecastTableView = UITableView()
    
    // MARK: - Initializers
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        checkWeatherAPIKey()
        setupLocationUpdates()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // background image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "forest_sunny") // Change this depending on data from API
        view.addSubview(backgroundImageView)
        
        // stack view
        temperatureStackView.axis = .vertical
        temperatureStackView.alignment = .center
        temperatureStackView.distribution = .equalSpacing
        temperatureStackView.spacing = 8
        temperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Favourite button
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favouriteButton.imageView?.contentMode = .scaleAspectFill
        favouriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // Semi-transparent black
        favouriteButton.layer.cornerRadius = 25
        favouriteButton.clipsToBounds = true
        favouriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        view.addSubview(favouriteButton)
        
        // temp label
        tempLabel.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        tempLabel.textColor = UIColor.label
        tempLabel.text = "25°" // Change this depending on data from API
        temperatureStackView.addArrangedSubview(tempLabel)
        
        // description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        descriptionLabel.textColor = UIColor.label
        descriptionLabel.text = "Sunny" // Change this depending on data from API
        temperatureStackView.addArrangedSubview(descriptionLabel)
        backgroundImageView.addSubview(temperatureStackView)
        
        // horizontal stack view (min, current, max)
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 16
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        
        // min stack view
        Utilities.configureVerticalStackView(
            stackView: minStackView,
            valueLabel: minLabel,
            descriptionLabel: minDescriptionLabel,
            value: "19°",
            description: "Min"
        )
        horizontalStackView.addArrangedSubview(minStackView)
        
        // current stack view
        Utilities.configureVerticalStackView(
            stackView: currentStackView,
            valueLabel: currentLabel,
            descriptionLabel: currentDescriptionLabel,
            value: "25°",
            description: "Current"
        )
        horizontalStackView.addArrangedSubview(currentStackView)
        
        // max stack view
        Utilities.configureVerticalStackView(
            stackView: maxStackView,
            valueLabel: maxLabel,
            descriptionLabel: maxDescriptionLabel,
            value: "27°",
            description: "Max"
        )
        horizontalStackView.addArrangedSubview(maxStackView)
        
        // separator view
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.label
        view.addSubview(separatorView)
        
        // table view
        forecastTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastCell")
        forecastTableView.dataSource = self
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forecastTableView)
        
        // Search Location Button
        searchLocationButton.setTitle("Search Locations", for: .normal)
        searchLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        searchLocationButton.setTitleColor(.systemBlue, for: .normal)
        searchLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchLocationButton)
        
        // Navigate to favourites view
        navigateToFavouritesButton.setTitle("View Favourites", for: .normal)
        navigateToFavouritesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        navigateToFavouritesButton.setTitleColor(.systemBlue, for: .normal)
        navigateToFavouritesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigateToFavouritesButton)
        
        // constraints
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.46),
            
            // Temperature stack view (on top of the background image)
            temperatureStackView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            temperatureStackView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            
            // Favourite button - top right corner
            favouriteButton.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 52),
            favouriteButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -32),
            favouriteButton.widthAnchor.constraint(equalToConstant: 50),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Horizontal stack view
            horizontalStackView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Separator view constraints
            separatorView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            separatorView.heightAnchor.constraint(equalToConstant: 1), // The thickness of the line
            
            // Table view
            forecastTableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: navigateToFavouritesButton.topAnchor, constant: -16),
            
            // Navigate to Favourites Button
            navigateToFavouritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            navigateToFavouritesButton.trailingAnchor.constraint(equalTo: searchLocationButton.leadingAnchor, constant: -8),
            navigateToFavouritesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            navigateToFavouritesButton.heightAnchor.constraint(equalToConstant: 44),
            navigateToFavouritesButton.widthAnchor.constraint(equalTo: searchLocationButton.widthAnchor), // Equal widths

            // Search Location Button
            searchLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            searchLocationButton.heightAnchor.constraint(equalToConstant: 44),
            
        ])
        
        // Attach actions to the buttons
        navigateToFavouritesButton.addTarget(self, action: #selector(navigateToFavourites), for: .touchUpInside)
        searchLocationButton.addTarget(self, action: #selector(openSearchLocation), for: .touchUpInside)
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavourite()
    }
    
    // Method to update the favorite button appearance
    private func updateFavoriteButton(isFavorite: Bool) {
        self.isFavorite = isFavorite
        let imageName = isFavorite ? "star.fill" : "star"
        DispatchQueue.main.sync { [weak self] in
            self?.favouriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @objc private func navigateToFavourites() {
        let favouritesView = FavouritesView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: favouritesView)
        hostingController.title = "Favourites"
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc private func openSearchLocation() {
        let searchLocationView = UIHostingController(rootView: SearchLocationsView { [weak self] location in
            self?.viewModel.fetchWeatherForLocation(location)
        })
        present(searchLocationView, animated: true)
    }
    
    // MARK: - SETUP LOCATION UPDATES
    private func setupLocationUpdates() {
        locationManager.onLocationUpdate = { [weak self] location in
            print("User's location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self?.viewModel.fetchWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) // Fetch real location and use it
        }
        locationManager.startUpdatingLocation()
        
        locationManager.onError = { [weak self] error in
            self?.showErrorAlert(message: "Failed to get your location. Error: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Bind the VM
    private func bindViewModel() {
        // Bind current weather to update UI
        viewModel.$currentWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                guard let weather = weather else { return }
                self?.updateCurrentWeatherUI(with: weather)
            }
            .store(in: &cancellables)
        
        // Bind forecast data to reload the table view
        viewModel.$forecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] forecast in
                self?.forecastTableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind favourite locations to update UI
        viewModel.$isCurrentLocationFavourite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavourite in
                let imageName = isFavourite ? "star.fill" : "star"
                self?.favouriteButton.setImage(UIImage(systemName: imageName), for: .normal)
            }
            .store(in: &cancellables)
        
        // Handle error messages
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateCurrentWeatherUI(with weather: WeatherResponse) {
        tempLabel.text = "\(Int(weather.main?.temp ?? 00))°"
        descriptionLabel.text = weather.weather?.first?.description.capitalized
        
        minLabel.text = "\(Int(weather.main?.tempMin ?? 00))°"
        currentLabel.text = "\(Int(weather.main?.temp ?? 00))°"
        maxLabel.text = "\(Int(weather.main?.tempMax ?? 00))°"
        
        if let weatherCondition = weather.weather?.first?.main {
            UIView.animate(withDuration: 0.5) {
                self.updateWeatherMode(.rainy, for: weatherCondition)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .clear
        let forecast = viewModel.dailyForecasts[indexPath.row]
        cell.configure(day: forecast.dayOfWeek, icon: forecast.weatherIcon, temperature: forecast.temp)
        
        return cell
    }
}

// MARK: Other extensions
extension MainWeatherViewController {
     func updateWeatherMode(_ mode: WeatherMode, for weatherMain: String) {
        switch weatherMain.lowercased() {
        case "clear":
            view.backgroundColor = UIColor(named: "sunny")
            forecastTableView.backgroundColor = UIColor(named: "sunny")
            backgroundImageView.image = UIImage(named: "forest_sunny")
            
        case "rain":
            view.backgroundColor = UIColor(named: "rainy")
            forecastTableView.backgroundColor = UIColor(named: "rainy")
            backgroundImageView.image = UIImage(named: "forest_rainy")
            
        case "clouds":
            view.backgroundColor = UIColor(named: "cloudy")
            forecastTableView.backgroundColor = UIColor(named: "cloudy")
            backgroundImageView.image = UIImage(named: "forest_cloudy")
            
        default:
            view.backgroundColor = UIColor(named: "cloudy")
            forecastTableView.backgroundColor = UIColor(named: "cloudy")
            backgroundImageView.image = UIImage(named: "forest_cloudy")
        }
    }
    
    private func showErrorAlert(message: String) {
        Utilities.presentAlert(on: self, with: "ERROR", message: message)
    }
    
    private func checkWeatherAPIKey() {
        guard Bundle.main.weatherAPIKey != nil else {
            showErrorAlert(message: "Weather API Key is missing in the Info.plist.")
            return
        }
    }
}
