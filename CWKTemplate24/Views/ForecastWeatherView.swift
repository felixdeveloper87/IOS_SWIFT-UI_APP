//
//  CurrentWeatherView.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A view for displaying both hourly and daily weather forecasts.
///
/// This view integrates the `HourlyWeatherView` and `DailyWeatherView` components,
/// providing a comprehensive overview of the weather for the next hours and days.
/// It leverages a shared `WeatherMapPlaceViewModel` to fetch and manage weather data.
struct ForecastWeatherView: View {

    // MARK: - Environment Object

    /// The environment object that provides weather data and functionality.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background image with opacity for visual appeal.
            Image("sky")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.7)
            
            // Main content layout.
            VStack(spacing: 5) {
                // Hourly weather forecast section.
                HourlyWeatherView()
                    .frame(height: 250) // Fixed height for consistent layout.

                // Daily weather forecast section.
                DailyWeatherView()
            }
            .frame(height: 600) // Ensures the content fits within a defined height.
        }
    }
}

#Preview {
    ForecastWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
