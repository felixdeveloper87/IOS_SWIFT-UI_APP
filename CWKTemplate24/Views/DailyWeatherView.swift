//
//  DailyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

/// A view for displaying an 8-day weather forecast.
///
/// This view presents daily weather information, including date, weather condition,
/// temperature highs and lows, and corresponding icons for the selected location.
struct DailyWeatherView: View {
    /// The environment object that provides weather data and functionality.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// A state variable to control the loading indicator.
    @State private var isLoading = true

    // MARK: - Body

    var body: some View {
        VStack {
            // Title displaying the location's 8-day forecast.
            Text("8 Day Forecast Weather for current location")
                .font(.title)
                .padding()
            
            if isLoading {
                // Shows a loading indicator while data is being fetched.
                ProgressView("Fetching weather data...")
            } else if let weather = weatherMapPlaceViewModel.weatherDataModel {
                // Displays daily weather data in a vertical scrollable list.
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(weather.daily.prefix(8), id: \.id) { dailyData in
                            HStack {
                                // Displays the formatted date for each day.
                                Text(DateFormatterUtils.formattedDate(
                                    from: dailyData.dt + weather.timezoneOffset,
                                    format: "EEEE dd"
                                ))
                                .font(.headline)
                                
                                Spacer()
                                
                                // Displays the weather condition icon.
                                if let weatherCondition = dailyData.weather.first?.main {
                                    let iconName = WeatherIconHelper.getWeatherIconName(for: weatherCondition).rawValue
                                    Image(iconName)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }

                                // Displays the weather condition description.
                                if let weatherCondition = dailyData.weather.first?.main {
                                    Text(weatherCondition.rawValue.capitalized)
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                // Displays the maximum and minimum temperatures for the day.
                                VStack(alignment: .trailing) {
                                    Text("Max: \(Int(dailyData.temp.max))°C")
                                        .font(.subheadline)
                                    Text("Min: \(Int(dailyData.temp.min))°C")
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2)) // Adds a subtle background to each row.
                            .cornerRadius(10) // Rounded corners for each row.
                        }
                    }
                    .padding()
                }
            } else {
                // Message displayed when no weather data is available.
                Text("No weather data available.")
            }
        }
        .onAppear {
            loadWeatherData()
        }
    }

    // MARK: - Helper Functions

    /// Loads weather and air quality data when the view appears.
    private func loadWeatherData() {
        Task {
            isLoading = true
            await weatherMapPlaceViewModel.fetchWeatherAndAirQuality()
            isLoading = false
        }
    }
}

#Preview {
    DailyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
