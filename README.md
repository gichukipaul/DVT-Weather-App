# Weather App - DVT
A Swift-based weather application that fetches real-time weather data and forecasts based on the user's location. The app uses Combine to handle asynchronous data fetching and presents errors in a user-friendly manner with alerts. It integrates with the OpenWeather API for weather data.

<div style="display:flex; justify-content:center;">
  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/lauchLight.png" alt="Light Mode Screenshot 1" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/mainLight.png" alt="Light Mode Screenshot 2" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/searchLightt.png" alt="Light Mode Screenshot 3" width="220" />
  
  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/favLight.png" alt="Light Mode Screenshot 3" width="220" />
</div>
<br>
<div style="display:flex; justify-content:center;">
  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/launchDark.png" alt="Light Mode Screenshot 1" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/mainDark.png" alt="Light Mode Screenshot 2" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/searchDark.png" alt="Light Mode Screenshot 3" width="220" />
  
  <img src="https://github.com/gichukipaul/DVT-Weather-App/blob/main/screenshots/favDark.png" alt="Light Mode Screenshot 3" width="220" />
</div>

## Prerequisites
- [A valid Google Maps Api Key](https://developers.google.com/maps/documentation/android-sdk/get-api-key)
- [A valid Open Weather API Key](https://openweathermap.org/appid)
- **NOTE: This uses the 3.0 version of the OpenWeather API**

## Setup
- Signup and get a free API Key at [https://openweathermap.org/api](https://openweathermap.org/api)
- You can clone this project directly from XCode or use your terminal as below
   ```sh
   git@github.com:gichukipaul/DVT-Weather-App.git
   ```
- Load the project in XCode
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
- Search new locations and get weather forecasts.
- Error Handling: Provides meaningful error messages using alerts in case of failures.

## Usage
- Launch the app, and it will request the user's location.
Once granted, the app will fetch the current weather and forecast data based on the user's coordinates.
An alert will be presented if there is any error (such as no location access or network issues).

## Architecture
This project follows an MVVM (Model-View-ViewModel) architecture with the following components:

- Model: Represents the weather data (WeatherResponse, ForecastResponse).
- View: Displays the weather data to the user. The Main view is Programmatic UIKit and the rest are SwiftUI
- ViewModel: Manages the data fetching, provides data to the view, and handles errors.
- Combine: Used for handling asynchronous data fetching and combining the results of multiple API calls (weather and forecast).
- Custom Error Handling: Errors are modelled using enums and displayed to the user via alerts.
- Error Handling: - The project uses a custom error enum to handle errors more effectively.

## Acknowledgements
- [Openweathermap.org](Openweathermap.org) : For the API endpoint to source the weather data
- [https://app.quicktype.io/?l=swift](https://app.quicktype.io/?l=swift) : JSON to Swift Models
- [Iconfinder.com](Iconfinder.com ) : I got the AppIcon from there

License
This project is licensed under the MIT License - see the LICENSE file for details.
