# Weather App - DVT
A Swift-based weather application that fetches real-time weather data and forecasts based on the user's location. The app uses Combine for handling asynchronous data fetching and presents errors in a user-friendly manner with alerts. It integrates with the OpenWeather API for weather data.

## Features
- Current Weather: Fetches current weather data based on the user's location.
- Weather Forecast: Provides a 5-day weather forecast with daily details.
- Location Updates: Automatically fetches weather data based on the user's GPS location.
- Error Handling: Provides meaningful error messages using alerts in case of failures.

## Requirements
- iOS 14.0+
- Xcode 15.0+
- Swift 5.0+
Installation

1. Add your OpenWeather API Key
Add your OpenWeather API Key in the Info.plist file:

```xml
<key>weatherAPIKey</key> 
<string>Your-OpenWeather-API-Key</string>
```
## Usage
- Launch the app, and it will request the user's location.
Once granted, the app will fetch the current weather and forecast data based on the user's coordinates.
If there's any error (such as no location access or network issues), an alert will be presented.

## Architecture
This project follows a MVVM (Model-View-ViewModel) architecture with the following components:

- Model: Represents the weather data (WeatherResponse, ForecastResponse).
- View: Displays the weather data to the user.
- ViewModel: Manages the data fetching, provides data to the view, and handles errors.
- Combine: Used for handling asynchronous data fetching and combining the results of multiple API calls (weather and forecast).
- Custom Error Handling: Errors are modeled using enums and displayed to the user via alerts.
- Error Handling: - The project uses a custom error enum to handle errors more effectively:

License
This project is licensed under the MIT License - see the LICENSE file for details.
