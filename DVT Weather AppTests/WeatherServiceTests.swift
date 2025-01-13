//
//  WeatherServiceTests.swift
//  DVT Weather AppTests
//
//  Created by GICHUKI on 14/01/2025.
//

import XCTest
@testable import DVT_Weather_App

class WeatherServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var weatherService: WeatherService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        weatherService = WeatherService(networkService: mockNetworkService, apiKey: "testApiKey")
    }

    func loadMockJSON(named filename: String) -> Data {
        let bundle = Bundle(for: type(of: self)) // Reference the test bundle
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Could not find \(filename).json in test bundle.")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Failed to load \(filename).json: \(error.localizedDescription)")
        }
    }

    
    override func tearDown() {
        mockNetworkService = nil
        weatherService = nil
        super.tearDown()
    }

    func testFetchCurrentWeather_Success() {
        // Arrange
        let jsonData = loadMockJSON(named: "weatherResponse")
        mockNetworkService.mockResult = .success(jsonData)

        let expectation = self.expectation(description: "FetchCurrentWeather")

        // Act
        weatherService.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            // Assert
            switch result {
            case .success(let response):
                XCTAssertEqual(response.main?.temp, 296.42)
                XCTAssertEqual(response.weather?.first?.main, "Clouds")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchCurrentWeather_DecodingError() {
        // Arrange
        let invalidJsonData = """
        {
            "invalid": "data"
        }
        """.data(using: .utf8)!
        mockNetworkService.mockResult = .success(invalidJsonData)

        let expectation = self.expectation(description: "FetchCurrentWeather")

        // Act
        weatherService.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("Failed to decode"))
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchCurrentWeather_NetworkError() {
        // Arrange
        let networkError = NSError(domain: "Network", code: 1, userInfo: nil)
        mockNetworkService.mockResult = .failure(.networkError(networkError))

        let expectation = self.expectation(description: "FetchCurrentWeather")

        // Act
        weatherService.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription.contains("Network error"))
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchForecast_Success() {
        // Arrange
        let jsonData = loadMockJSON(named: "forecastResponse")
        mockNetworkService.mockResult = .success(jsonData)

        let expectation = self.expectation(description: "FetchForecast")

        // Act
        weatherService.fetchForecast(latitude: 37.7749, longitude: -122.4194) { result in
            // Assert
            switch result {
            case .success(let response):
                XCTAssertEqual(response.list.count, 40)
                XCTAssertEqual(response.list[0].main.temp, 296.24)
                XCTAssertEqual(response.list[1].weather.first?.main, "Rain")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
