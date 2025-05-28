//
//  AirQualityView.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A view for displaying current air quality data.
///
/// This view provides a summary of air quality for the selected location,
/// including the Air Quality Index (AQI) and specific pollutant levels.
/// It dynamically updates based on the data provided by the `WeatherMapPlaceViewModel`.
struct AirQualityView: View {
    /// The environment object that provides air quality and weather data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// A state variable to control the loading indicator.
    @State private var isLoading = true

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let airData = weatherMapPlaceViewModel.airDataModel {
                // Displays the current AQI for the selected location.
                HStack {
                    Text("Current Air Quality for \(weatherMapPlaceViewModel.newLocation):")
                        .font(.headline)
                        .padding()
                    Text("AQI:")
                        .font(.subheadline)
                        .bold()
                    Text("\(airData.list.first?.main.aqi ?? 0)")
                        .font(.title2)
                        .foregroundColor(getAQIColor(for: airData.list.first?.main.aqi ?? 0))
                }

                ZStack {
                    // Background image for visual appeal.
                    Image("bg")
                        .resizable()
                        .clipped()

                    // Display pollutant levels using the `ParameterView`.
                    HStack(spacing: 40) {
                        ParameterView(value: airData.list.first?.components.so2, imageName: "so2")
                        ParameterView(value: airData.list.first?.components.no2, imageName: "no")
                        ParameterView(value: airData.list.first?.components.co, imageName: "voc")
                        ParameterView(value: airData.list.first?.components.o3, imageName: "pm")
                    }
                }
                .frame(height: 50)
            } else {
                // Message displayed when air quality data is loading.
                Text("Loading Air Quality Data...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
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

    /// Returns the appropriate colour for the AQI value.
    ///
    /// - Parameter aqi: The Air Quality Index value.
    /// - Returns: A `Color` representing the air quality level.
    private func getAQIColor(for aqi: Int) -> Color {
        switch aqi {
        case 1:
            return .green // Good
        case 2:
            return .yellow // Moderate
        case 3:
            return .orange // Unhealthy for Sensitive Groups
        case 4:
            return .red // Unhealthy
        case 5:
            return .purple // Very Unhealthy
        default:
            return .gray // Unknown or missing data
        }
    }
}

#Preview {
    AirQualityView()
        .environmentObject(WeatherMapPlaceViewModel())
}
