# Weather App - DVT
A Swift-based weather application that fetches real-time weather data and forecasts based on the user's location. The app uses Combine for handling asynchronous data fetching and presents errors in a user-friendly manner with alerts. It integrates with the OpenWeather API for weather data.

## Pre Requisities
- [A valid Google Maps Api Key](https://developers.google.com/maps/documentation/android-sdk/get-api-key)
- [A valid Open Weather API Key](https://openweathermap.org/appid)
- **NOTE: This uses the 3.0 version of the openweather API**

## Setup
- Open the `Info.plist` on the project
- Change `weatherAPIKey` to your API key and Save the file.
```xml
<key>weatherAPIKey</key> 
<string>Your-OpenWeather-API-Key</string>
```
- Build the project

## Features
- Current Weather: Fetches current weather data based on the user's location.
- Weather Forecast: Provides a 5-day weather forecast with daily details.
- Search new locations and get weather forecast.
- Error Handling: Provides meaningful error messages using alerts in case of failures.

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
- Error Handling: - The project uses a custom error enum to handle errors more effectively.

## Acknowledgements
- [Openweathermap.org](Openweathermap.org) : For the API endpoint to source the weather data
- [Iconfinder.com](Iconfinder.com ) : I got the AppIcon from there

License
This project is licensed under the MIT License - see the LICENSE file for details.
