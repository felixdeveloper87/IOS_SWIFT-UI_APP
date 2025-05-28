//
//  VisitedPlacesView.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A view for displaying and managing a list of saved locations.
///
/// This view provides a user-friendly interface to view previously saved places,
/// select a location to fetch weather and air quality data, and delete locations from the list.
struct VisitedPlacesView: View {
    /// The environment object that manages weather and location data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        ZStack {
            // Background image for visual enhancement.
            Image("sky")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.7)

            // Main content layout.
            VStack {
                // Title for the section.
                Text("Saved Places")
                    .font(.title)
                    .padding()

                if weatherMapPlaceViewModel.savedLocations.isEmpty {
                    // Message displayed when no locations are saved.
                    Text("No saved places yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // List of saved locations.
                    List {
                        ForEach(weatherMapPlaceViewModel.savedLocations) { location in
                            HStack {
                                VStack(alignment: .leading) {
                                    // Display the name of the location.
                                    Text(location.name)
                                        .font(.headline)

                                    // Display the latitude and longitude of the location.
                                    Text("Lat: \(String(format: "%.2f", location.latitude)), Lon: \(String(format: "%.2f", location.longitude))")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                            .padding()
                            .contentShape(Rectangle()) // Makes the entire row tappable.
                            .listRowBackground(Color.clear) // Sets row background to transparent.
                            .onTapGesture {
                                selectLocation(location: location)
                            }
                            .swipeActions(edge: .trailing) {
                                // Swipe action to delete a location.
                                Button(role: .destructive) {
                                    deleteLocation(location: location)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle()) // Ensures a plain style for the list.
                }
            }
            .padding()
        }
    }

    // MARK: - Helper Functions

    /// Selects a location and fetches weather and air quality data for it.
    ///
    /// - Parameter location: The location to be selected.
    private func selectLocation(location: LocationModel) {
        Task {
            weatherMapPlaceViewModel.newLocation = location.name
            weatherMapPlaceViewModel.currentLocation = location

            do {
                try await weatherMapPlaceViewModel.fetchWeatherData(lat: location.latitude, lon: location.longitude)
                try await weatherMapPlaceViewModel.fetchAirQualityData(lat: location.latitude, lon: location.longitude)
            } catch {
                print("Error fetching data for \(location.name): \(error)")
            }
        }
    }

    /// Deletes a location from the saved locations list.
    ///
    /// - Parameter location: The location to be deleted.
    private func deleteLocation(location: LocationModel) {
        if let index = weatherMapPlaceViewModel.savedLocations.firstIndex(where: { $0.id == location.id }) {
            weatherMapPlaceViewModel.savedLocations.remove(at: index)
        }

        // Reset to default location after deletion.
        weatherMapPlaceViewModel.newLocation = "London"
        weatherMapPlaceViewModel.currentLocation = LocationModel(name: "London", latitude: 51.5074, longitude: -0.1278)
    }
}

#Preview {
    VisitedPlacesView()
        .environmentObject(WeatherMapPlaceViewModel())
}
