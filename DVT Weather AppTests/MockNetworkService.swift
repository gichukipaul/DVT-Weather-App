//
//  MockNetworkService.swift
//  DVT Weather AppTests
//
//  Created by GICHUKI on 14/01/2025.
//

import Foundation
@testable import DVT_Weather_App

class MockNetworkService: NetworkServiceProtocol {
    var mockResult: Result<Data, WeatherServiceError>?

    func requestData(from url: URL, completion: @escaping (Result<Data, WeatherServiceError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
