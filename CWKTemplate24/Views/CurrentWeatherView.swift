//
//  CurrentWeatherView.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A view for displaying the current weather and air quality data for a selected location.
///
/// This view shows details such as temperature, weather conditions, wind speed, humidity,
/// and pressure. It also integrates an `AirQualityView` for displaying air quality information.
struct CurrentWeatherView: View {
    /// The environment object managing weather and air quality data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// A state variable to control the loading indicator.
    @State private var isLoading = true

    var body: some View {
        ZStack {
            // Background image for aesthetic enhancement.
            Image("sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.7)
            
            // Main content layout.
            VStack(alignment: .leading, spacing: 10) {
                if isLoading {
                    // Shows a loading indicator while data is being fetched.
                    ProgressView("Fetching weather data...")
                } else if let weather = weatherMapPlaceViewModel.weatherDataModel {
                    // Displays weather details when data is available.
                    VStack(alignment: .leading, spacing: 4) {
                        // Location and date information.
                        VStack {
                            Text(weatherMapPlaceViewModel.newLocation)
                                .font(.title2)
                                .bold()
                            
                            Text(
                                DateFormatterUtils.formattedDate(
                                    from: Int(Date().timeIntervalSince1970) + weather.timezoneOffset,
                                    format: "dd MMMM yyyy 'at' HH:mm"
                                )
                            )
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.secondary)
                            .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Weather condition and temperature details.
                        HStack {
                            if let weatherCondition = weather.current.weather.first?.main {
                                let iconName = WeatherIconHelper.getWeatherIconName(for: weatherCondition).rawValue
                                Image(iconName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            
                            if let weatherDescription = weather.current.weather.first?.weatherDescription.rawValue {
                                Text(weatherDescription.capitalized)
                                    .font(.headline)
                            }
                            Text("Feels like: \(String(format: "%.1f", weather.current.feelsLike))°C")
                        }
                        
                        // High and low temperatures.
                        HStack {
                            Image("temperature")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("H:: \(String(format: "%.1f", weather.daily.first?.temp.max ?? 0.0))°C")
                            Text("L:: \(String(format: "%.1f", weather.daily.first?.temp.min ?? 0.0))°C")
                        }
                        
                        // Wind speed details.
                        HStack {
                            Image("windSpeed")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Wind speed: \(String(format: "%.1f", weather.current.windSpeed)) m/s")
                        }
                        
                        // Humidity details.
                        HStack {
                            Image("humidity")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Humidity: \(weather.current.humidity)%")
                        }
                        
                        // Pressure details.
                        HStack {
                            Image("pressure")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Pressure: \(weather.current.pressure) hPa")
                        }
                    }
                    .padding()
                } else {
                    // Displays a message when no weather data is available.
                    Text("No weather data available.")
                        .foregroundColor(.red)
                }
                
                // Air quality view integrated below weather details.
                AirQualityView()
                    .environmentObject(weatherMapPlaceViewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                Task {
                    await fetchDataForDefaultCity()
                }
            }
        }
    }

    // MARK: - Helper Functions

    /// Fetches weather and air quality data for the default city when the view appears.
    private func fetchDataForDefaultCity() async {
        isLoading = true
        await weatherMapPlaceViewModel.fetchWeatherAndAirQuality()
        isLoading = false
    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
