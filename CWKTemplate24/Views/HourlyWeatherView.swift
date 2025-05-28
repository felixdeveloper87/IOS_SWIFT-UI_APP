//
//  HourlyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

/// A view for displaying the hourly weather forecast.
///
/// This view shows a horizontal scrollable list of weather data for the next 10 hours,
/// including temperature, weather condition, and corresponding icons.
/// It dynamically updates based on the data provided by the `WeatherMapPlaceViewModel`.
struct HourlyWeatherView: View {
    /// The environment object that provides weather data and functionality.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// A state variable to control the loading indicator.
    @State private var isLoading = true

    // MARK: - Body

    var body: some View {
        VStack {
            // Title displaying the location's hourly forecast.
            Text("Hourly Forecast Weather for \(weatherMapPlaceViewModel.newLocation)")
                .font(.title)
                .padding()

            if isLoading {
                // Shows a loading indicator while data is being fetched.
                ProgressView("Fetching weather data...")
            } else if let weather = weatherMapPlaceViewModel.weatherDataModel {
                // Displays hourly weather data in a horizontal scrollable list.
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(weather.hourly.prefix(10), id: \.id) { hourlyData in
                            VStack {
                                // Formats and displays the time and day using `DateFormatterUtils`.
                                Text(DateFormatterUtils.formattedDateWithDay(from: TimeInterval(hourlyData.dt + weather.timezoneOffset)))
                                    .font(.headline)

                                // Displays the weather condition icon.
                                if let weatherCondition = hourlyData.weather.first?.main {
                                    let iconName = WeatherIconHelper.getWeatherIconName(for: weatherCondition).rawValue
                                    Image(iconName)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }

                                // Displays the temperature.
                                Text("Temp: \(Int(hourlyData.temp))°C")
                                    .font(.subheadline)

                                // Displays the weather condition description.
                                if let weatherCondition = hourlyData.weather.first?.main {
                                    Text(weatherCondition.rawValue.capitalized)
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2)) // Adds a subtle background to each card.
                            .cornerRadius(10) // Rounded corners for each card.
                        }
                    }
                }
                .frame(height: 150) // Sets the height of the horizontal scrollable list.
            } else {
                // Message displayed when no weather data is available.
                Text("No weather data available.")
            }
        }
        .onAppear {
            loadDefaultWeatherData()
        }
    }

    // MARK: - Helper Functions

    /// Loads the default weather and air quality data when the view appears.
    private func loadDefaultWeatherData() {
        Task {
            isLoading = true
            await weatherMapPlaceViewModel.fetchWeatherAndAirQuality()
            isLoading = false
        }
    }
}

#Preview {
    HourlyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
