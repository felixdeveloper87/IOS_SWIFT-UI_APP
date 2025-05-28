//
//  HeaderView.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A reusable header component that allows users to search for and update the weather location.
///
/// This view includes a search bar, a button to trigger the search, and background styling.
/// It integrates with the `WeatherMapPlaceViewModel` to fetch and manage weather and air quality data.
struct HeaderView: View {
    /// The view model responsible for managing weather and location data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// The current text entered in the search bar.
    @State private var searchText = ""

    /// A state variable to control the display of a duplicate location alert.
    @State private var showDuplicateAlert = false

    var body: some View {
        ZStack {
            // Background image with opacity for visual enhancement.
            Image("bg")
                .resizable()
                .clipped()
                .opacity(0.5)
                .scaledToFill()

            HStack {
                // Text prompting the user to change the location.
                Text("Change Location")
                    .bold()

                // Search bar for entering a new location.
                TextField("Search new location", text: $searchText, onCommit: {
                    Task {
                        await searchLocation()
                    }
                })
                .padding()
                .frame(width: 200, height: 40)
                .background(Color.white) // White background for the text field.
                .cornerRadius(10) // Rounded corners for aesthetic appeal.
                .shadow(color: Color.blue.opacity(0.5), radius: 8, x: 0, y: 0) // Blue shadow for emphasis.
                .padding(.horizontal)

                // Button to trigger the location search.
                Button(action: {
                    Task {
                        await searchLocation()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 28))
                }
                .padding(.trailing)
            }
            // Alert for general errors, showing the error message from the view model.
            .alert("Error", isPresented: $weatherMapPlaceViewModel.showErrorAlert) {
                Button("OK", role: .cancel) {
                    weatherMapPlaceViewModel.showErrorAlert = false
                    weatherMapPlaceViewModel.errorMessage = nil
                }
            } message: {
                Text(weatherMapPlaceViewModel.errorMessage ?? "An unknown error occurred.")
            }
            // Alert for duplicate locations already saved in the list.
            .alert("Location already saved", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The location '\(searchText)' is already in your saved places.")
            }
        }
    }

    /// Searches for a location by name and updates the weather and air quality data.
    ///
    /// This function checks if the location is already saved, fetches its coordinates,
    /// retrieves weather and air quality data, and saves the new location if successful.
    private func searchLocation() async {
        // Ensure the search text is not empty.
        guard !searchText.isEmpty else { return }

        // Check if the location is already in the saved list.
        if weatherMapPlaceViewModel.savedLocations.contains(where: { $0.name.lowercased() == searchText.lowercased() }) {
            showDuplicateAlert = true
            return
        }

        do {
            // Fetch coordinates for the given city name.
            if let coordinates = try await weatherMapPlaceViewModel.getCoordinatesForCity(location: searchText) {
                weatherMapPlaceViewModel.newLocation = searchText
                
                // Fetch weather and air quality data asynchronously.
                try await weatherMapPlaceViewModel.fetchWeatherData(lat: coordinates.lat, lon: coordinates.lon)
                try await weatherMapPlaceViewModel.fetchAirQualityData(lat: coordinates.lat, lon: coordinates.lon)

                // Update the current location without awaiting (UI update happens on the main thread).
                DispatchQueue.main.async {
                    weatherMapPlaceViewModel.currentLocation = LocationModel(
                        name: searchText,
                        latitude: coordinates.lat,
                        longitude: coordinates.lon
                    )
                }

                // Save the new location to the list of saved locations.
                weatherMapPlaceViewModel.saveLocation(name: searchText, latitude: coordinates.lat, longitude: coordinates.lon)
            } else {
                print("City not found")
            }
        } catch {
            print("Failed to search location: \(error)")
        }
    }
}

#Preview {
    HeaderView()
        .environmentObject(WeatherMapPlaceViewModel())
}
