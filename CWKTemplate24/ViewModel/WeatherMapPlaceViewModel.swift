//
//  WeatherMapPlaceViewModel.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import Foundation
import CoreLocation
import SwiftData
import SwiftUI

/// A view model for managing weather and air quality data, along with saved locations.
///
/// This class serves as the core logic for fetching, storing, and managing location-based
/// weather and air quality data. It interacts with APIs, handles errors gracefully, and
/// manages state changes to ensure seamless updates to the UI.
class WeatherMapPlaceViewModel: ObservableObject {

    // MARK: - Published Variables

    /// The main weather data model for the selected location.
    @Published var weatherDataModel: WeatherDataModel?

    /// The current location name for which data is being fetched. Default is "London".
    @Published var newLocation = "London"

    /// A list of saved locations, stored persistently in `AppStorage`.
    @AppStorage("savedLocations") private var savedLocationsData: Data = Data() // Stores locations as JSON.
    @Published var savedLocations: [LocationModel] = [] {
        didSet {
            saveLocationsToAppStorage()
        }
    }

    /// The currently selected location's data.
    @Published var currentLocation: LocationModel?

    /// An error message to display when a fetch operation fails.
    @Published var errorMessage: String?

    /// A Boolean to control the visibility of error alerts.
    @Published var showErrorAlert: Bool = false

    /// The air quality data model for the selected location.
    @Published var airDataModel: AirDataModel?

    /// API Key for accessing OpenWeatherMap APIs.
    private let apiKey = "e95265ec87670e7e1d84bd49cff7e84c"

    /// Context for SwiftData operations.
    var modelContext: ModelContext?

    // MARK: - Initialisation

    /// Initialises the view model and loads saved locations from persistent storage.
    init() {
        loadLocationsFromAppStorage()
    }

    // MARK: - AppStorage Management

    /// Saves the list of saved locations to `AppStorage`.
    private func saveLocationsToAppStorage() {
        do {
            let data = try JSONEncoder().encode(savedLocations)
            savedLocationsData = data
        } catch {
            print("Error saving locations to AppStorage: \(error)")
        }
    }

    /// Loads the list of saved locations from `AppStorage`.
    private func loadLocationsFromAppStorage() {
        do {
            let locations = try JSONDecoder().decode([LocationModel].self, from: savedLocationsData)
            savedLocations = locations
        } catch {
            print("Error loading locations from AppStorage: \(error)")
        }
    }

    // MARK: - Geocoding

    /// Fetches the coordinates (latitude and longitude) for a given city name.
    ///
    /// - Parameter location: The name of the city to geocode.
    /// - Returns: A tuple containing the latitude and longitude of the city, or `nil` if not found.
    func getCoordinatesForCity(location: String) async throws -> (lat: Double, lon: Double)? {
        let geocoder = CLGeocoder()
        do {
            let results = try await geocoder.geocodeAddressString(location)
            guard let geoLocation = results.first?.location else {
                DispatchQueue.main.async {
                    self.errorMessage = "City '\(location)' not found."
                    self.showErrorAlert = true
                }
                return nil
            }
            return (lat: geoLocation.coordinate.latitude, lon: geoLocation.coordinate.longitude)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch coordinates: \(error.localizedDescription)"
                self.showErrorAlert = true
            }
            throw error
        }
    }

    // MARK: - Fetch Weather Data

    /// Fetches weather data for a given latitude and longitude using the OpenWeatherMap API.
    ///
    /// - Parameters:
    ///   - lat: The latitude of the location.
    ///   - lon: The longitude of the location.
    func fetchWeatherData(lat: Double, lon: Double) async throws {
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL for weather data."
                self.showErrorAlert = true
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode(WeatherDataModel.self, from: data)
            DispatchQueue.main.async {
                self.weatherDataModel = weatherResponse
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                self.showErrorAlert = true
            }
            throw error
        }
    }

    // MARK: - Fetch Air Quality Data

    /// Fetches air quality data for a given latitude and longitude using the OpenWeatherMap API.
    ///
    /// - Parameters:
    ///   - lat: The latitude of the location.
    ///   - lon: The longitude of the location.
    func fetchAirQualityData(lat: Double, lon: Double) async throws {
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let airDataResponse = try JSONDecoder().decode(AirDataModel.self, from: data)
            DispatchQueue.main.async {
                self.airDataModel = airDataResponse
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch air quality data: \(error.localizedDescription)"
                self.showErrorAlert = true
            }
            throw error
        }
    }

    // MARK: - Fetch Weather and Air Quality Data

    /// Fetches both weather and air quality data for the currently selected location.
    func fetchWeatherAndAirQuality() async {
        do {
            if let coordinates = try await getCoordinatesForCity(location: newLocation) {
                try await fetchWeatherData(lat: coordinates.lat, lon: coordinates.lon)
                try await fetchAirQualityData(lat: coordinates.lat, lon: coordinates.lon)
                DispatchQueue.main.async {
                    self.currentLocation = LocationModel(name: self.newLocation, latitude: coordinates.lat, longitude: coordinates.lon)
                }
            }
        } catch {
            print("Error fetching weather and air quality data: \(error)")
        }
    }

    // MARK: - Save Location

    /// Saves a new location to the list of saved locations.
    ///
    /// - Parameters:
    ///   - name: The name of the location.
    ///   - latitude: The latitude of the location.
    ///   - longitude: The longitude of the location.
    func saveLocation(name: String, latitude: Double, longitude: Double) {
        let newLocation = LocationModel(name: name, latitude: latitude, longitude: longitude)
        if !savedLocations.contains(where: { $0.name.lowercased() == name.lowercased() }) {
            savedLocations.append(newLocation)
        }
    }

    // MARK: - Set Annotations for Map

    /// Fetches and sets tourist place annotations for a specific map region.
    ///
    /// This method is currently a placeholder and should be implemented to handle
    /// the fetching and storage of tourist places for use on a map.
    func setAnnotations() async throws {
        // Implementation to be added with appropriate comments.
    }
}
