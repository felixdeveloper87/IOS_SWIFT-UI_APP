//
//  WeatherIconHelper.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 06/01/2025.
//

import Foundation

/// Represents the available weather icons for different weather conditions.
/// Each case corresponds to a specific icon that will visually represent
/// the weather condition returned by the weather data model.
enum WeatherIcon: String {
    case sun       // Represents clear sky
    case cloud     // Represents cloudy conditions
    case rain      // Represents rain
    case snowy     // Represents snowy weather
    case mist      // Represents mist or fog
    case stormy    // Represents thunderstorms
    case `default` // Fallback icon for unhandled conditions
}

/// A utility class to map weather conditions to their corresponding icons.
/// This abstraction ensures that the app has a consistent and extensible way
/// to display weather-related visuals across various components.
class WeatherIconHelper {

    /// Maps a `Main` weather condition to its corresponding `WeatherIcon`.
    ///
    /// - Parameter condition: The primary weather condition as defined by the `Main` enum.
    /// - Returns: A `WeatherIcon` corresponding to the given weather condition.
    ///
    /// This method uses a `switch` statement to ensure that each weather condition
    /// is explicitly mapped to a predefined icon. If no match is found, a default
    /// icon is returned to prevent the application from breaking or displaying
    /// incomplete visuals.
    static func getWeatherIconName(for condition: Main) -> WeatherIcon {
        switch condition {
        case .clear:
            return .sun       // Clear skies are represented by the sun icon
        case .clouds:
            return .cloud     // Cloudy conditions are represented by the cloud icon
        case .rain:
            return .rain      // Rain conditions are represented by the rain icon
        case .snow:
            return .snowy     // Snowy conditions are represented by the snowy icon
        case .mist:
            return .mist      // Mist or fog conditions are represented by the mist icon
        case .thunderstorm:
            return .stormy    // Thunderstorms are represented by the stormy icon
        default:
            return .default   // Any unhandled condition will use the default icon
        }
    }
}
