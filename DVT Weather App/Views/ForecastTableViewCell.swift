//
//  ForecastTableViewCell.swift
//  DVT Weather App
//
//  Created by GICHUKI on 10/01/2025.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    // UI Components
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // TODO: Is there a better way to handle this?
    }
    
    private func setupUI() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            // Day of Week Label
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Weather Icon
            weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 24),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            // Temperature Label
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // Configure the Cell
    func configure(day: String, icon: UIImage?, temperature: String) {
        dayLabel.text = day
        weatherIconImageView.image = icon
        temperatureLabel.text = temperature
    }
}

