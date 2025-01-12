//
//  Extenssions+.swift
//  DVT Weather App
//
//  Created by GICHUKI on 12/01/2025.
//

import Foundation

extension Bundle {
    var weatherAPIKey: String {
        guard let key = object(forInfoDictionaryKey: "weatherAPIKey") as? String else {
            fatalError("OpenWeatherAPIKey not found in Info.plist")
        }
        return key
    }
}

extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
