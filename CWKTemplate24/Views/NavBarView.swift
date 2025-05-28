//
//  HeaderView.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A navigation bar view that manages the layout and tab navigation for the application.
///
/// This view integrates a customisable `TabView` and a `HeaderView` at the top.
/// It acts as the main entry point for navigating between different sections of the app,
/// such as the current weather, weather forecast, map, and stored places.
struct NavBarView: View {
    
    /// The environment object used to manage weather and location data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    // MARK: - Initialiser for TabView Appearance

    /// Customises the appearance of the `TabView` to ensure a consistent design.
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Sets the tab bar background colour to white.
        UITabBar.appearance().standardAppearance = appearance
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // HeaderView at the top of the screen.
            HeaderView()
                .environmentObject(weatherMapPlaceViewModel) // Passes the environment object to the HeaderView.
                .frame(maxWidth: .infinity, maxHeight: 70) // Sets the size of the header.

            // Main TabView containing different sections of the app.
            TabView {
                // Current weather view tab.
                CurrentWeatherView()
                    .tabItem {
                        Label("Now", systemImage: "sun.max.fill")
                    }

                // 5-day weather forecast view tab.
                ForecastWeatherView()
                    .tabItem {
                        Label("5-Day Weather", systemImage: "calendar")
                    }

                // Map view tab showing places on a map.
                MapView()
                    .tabItem {
                        Label("Place Map", systemImage: "map")
                    }

                // View showing stored places.
                VisitedPlacesView()
                    .tabItem {
                        Label("Stored Places", systemImage: "globe")
                    }
            }
        }
    }
}

#Preview {
    NavBarView()
        .environmentObject(WeatherMapPlaceViewModel())
}
