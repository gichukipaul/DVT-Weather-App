//
//  MainWeatherViewController.swift
//  DVT Weather App
//
//  Created by GICHUKI on 10/01/2025.
//

import UIKit

class MainWeatherViewController: UIViewController {
    // MARK: - UI Elements
    private let backgroundImageView = UIImageView()
    private let temperatureStackView = UIStackView()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()

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

    private let forecastTableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // for testing
        UIView.animate(withDuration: 0.5) {
            self.updateWeatherMode(.rainy)
        }

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

        // temp label
        tempLabel.font = UIFont.systemFont(ofSize: 64, weight: .bold)
        tempLabel.textColor = .white
        tempLabel.text = "25°" // Change this depending on data from API
        temperatureStackView.addArrangedSubview(tempLabel)

        // description label
        descriptionLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        descriptionLabel.textColor = .white
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
        configureVerticalStackView(
            stackView: minStackView,
            valueLabel: minLabel,
            descriptionLabel: minDescriptionLabel,
            value: "19°",
            description: "Min"
        )
        horizontalStackView.addArrangedSubview(minStackView)

        // current stack view
        configureVerticalStackView(
            stackView: currentStackView,
            valueLabel: currentLabel,
            descriptionLabel: currentDescriptionLabel,
            value: "25°",
            description: "Current"
        )
        horizontalStackView.addArrangedSubview(currentStackView)

        // max stack view
        configureVerticalStackView(
            stackView: maxStackView,
            valueLabel: maxLabel,
            descriptionLabel: maxDescriptionLabel,
            value: "27°",
            description: "Max"
        )
        horizontalStackView.addArrangedSubview(maxStackView)

        // table view
        forecastTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastCell")
        forecastTableView.dataSource = self
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forecastTableView)

        // constraints
        NSLayoutConstraint.activate([
            // background image
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            // temperature stack view which is on top of background image
            temperatureStackView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            temperatureStackView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),

            // horizontal stack view
            horizontalStackView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 16),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // table view
            forecastTableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // a helper function to configure a vertical stack view
    private func configureVerticalStackView(
        stackView: UIStackView,
        valueLabel: UILabel,
        descriptionLabel: UILabel,
        value: String,
        description: String
    ) {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.text = value
        stackView.addArrangedSubview(valueLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.text = description
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    // for initial testing
    func updateWeatherMode(_ mode: WeatherMode) {
        switch mode {
        case .sunny:
            view.backgroundColor = UIColor(named: "sunny")
            backgroundImageView.image = UIImage(named: "forest_sunny")

        case .rainy:
            view.backgroundColor = UIColor(named: "rainy")
            backgroundImageView.image = UIImage(named: "forest_rainy")

        case .cloudy:
            view.backgroundColor = UIColor(named: "cloudy")
            backgroundImageView.image = UIImage(named: "forest_cloudy")
        }
    }

}

// MARK: - UITableViewDataSource
extension MainWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // for a Five-day forecast
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }

        // test data
        let day = "Monday"
        let icon = UIImage(named: "partlysunny") // Replace this dynamically
        let temperature = "20°"

        cell.configure(day: day, icon: icon, temperature: temperature)
        return cell
    }
}

enum WeatherMode {
    case sunny
    case rainy
    case cloudy
}
