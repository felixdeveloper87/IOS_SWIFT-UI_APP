//
//  LocationModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation

/// A model class to represent a geographic location, used with SwiftData for persistent storage.
///
/// This class is designed to store metadata about specific places, including their names,
/// geographic coordinates, and optional weather conditions. It conforms to `Codable` for
/// serialisation, `Identifiable` for SwiftUI integration, and `Equatable` for easy comparison.
class LocationModel: Codable, Identifiable, Equatable {
    /// A unique identifier for each location instance.
    var id: UUID
    
    /// The name of the location (e.g., "London").
    var name: String
    
    /// The latitude of the location.
    var latitude: Double
    
    /// The longitude of the location.
    var longitude: Double
    
    /// The weather condition associated with the location, if available.
    var weatherCondition: Main?

    /// Initialises a new `LocationModel` instance with the provided attributes.
    ///
    /// - Parameters:
    ///   - name: The name of the location.
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    ///   - weatherCondition: An optional `Main` instance representing the weather condition.
    init(name: String, latitude: Double, longitude: Double, weatherCondition: Main? = nil) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.weatherCondition = weatherCondition
    }

    // MARK: - Equatable
    /// Compares two `LocationModel` instances for equality.
    ///
    /// Two locations are considered equal if their `id`, `name`, `latitude`, `longitude`,
    /// and `weatherCondition` properties are all identical.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `LocationModel` instance.
    ///   - rhs: The right-hand side `LocationModel` instance.
    /// - Returns: A Boolean indicating whether the two instances are equal.
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude &&
               lhs.weatherCondition == rhs.weatherCondition
    }
}
