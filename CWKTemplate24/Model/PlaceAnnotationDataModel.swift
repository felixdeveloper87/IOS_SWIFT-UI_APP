//
//  PlaceAnnotationDataModel.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/12/2024.
//

import Foundation
import CoreLocation

/// A data model for representing map annotations of tourist places.
///
/// This structure is used to manage the metadata and coordinates of places
/// to be displayed as pins on a map. It conforms to `Identifiable`, `Equatable`,
/// and `Hashable` protocols for seamless integration with SwiftUI and other collections.
struct PlaceAnnotationDataModel: Identifiable, Equatable, Hashable {
    /// A unique identifier for each annotation, ensuring compatibility with SwiftUI.
    let id = UUID()
    
    /// The name of the place (e.g., "Eiffel Tower").
    let name: String
    
    /// The geographic coordinates of the place.
    let coordinate: CLLocationCoordinate2D

    // MARK: - Equatable
    /// Compares two `PlaceAnnotationDataModel` instances for equality.
    ///
    /// Two instances are considered equal if their `id`, `name`, and `coordinate` properties match.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side instance to compare.
    ///   - rhs: The right-hand side instance to compare.
    /// - Returns: A Boolean indicating whether the two instances are equal.
    static func == (lhs: PlaceAnnotationDataModel, rhs: PlaceAnnotationDataModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }

    // MARK: - Hashable
    /// Generates a hash value for the `PlaceAnnotationDataModel` instance.
    ///
    /// This method combines the `id`, `name`, and geographic coordinates into a unique hash value,
    /// making the model compatible with collections such as `Set` or dictionary keys.
    ///
    /// - Parameter hasher: The hasher instance used to generate the hash value.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}
