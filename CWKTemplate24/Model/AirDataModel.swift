//
//  AirDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation

/// A data model for representing air quality information retrieved from the OpenWeather Pollution API.
///
/// This model decodes the API response into a structured format, capturing key details such as
/// air quality index (AQI) and concentrations of various pollutants. It supports the representation
/// of multiple air quality records in a single response.
struct AirDataModel: Codable {

    // MARK: - Main
    /// Represents the overall air quality index (AQI) for a specific time and location.
    ///
    /// - `aqi`: The Air Quality Index, an integer ranging from 1 (Good) to 5 (Very Poor), as defined by the API.
    struct Main: Codable {
        let aqi: Int // Air Quality Index (1 to 5)
    }

    // MARK: - Components
    /// Represents the concentrations of various pollutants in the air.
    ///
    /// Includes measurements for common pollutants such as carbon monoxide (CO),
    /// nitrogen dioxide (NO2), and particulate matter (PM2.5 and PM10).
    struct Components: Codable {
        let co: Double     // Carbon monoxide concentration (μg/m³)
        let no: Double     // Nitric oxide concentration (μg/m³)
        let no2: Double    // Nitrogen dioxide concentration (μg/m³)
        let o3: Double     // Ozone concentration (μg/m³)
        let so2: Double    // Sulphur dioxide concentration (μg/m³)
        let pm2_5: Double  // Particulate matter < 2.5 μm concentration (μg/m³)
        let pm10: Double   // Particulate matter < 10 μm concentration (μg/m³)
        let nh3: Double    // Ammonia concentration (μg/m³)
    }

    // MARK: - AirQuality
    /// Represents a single air quality record, including the AQI and pollutant concentrations.
    ///
    /// Each record is timestamped and contains a `Main` object for the AQI and a `Components`
    /// object for detailed pollutant measurements.
    struct AirQuality: Codable {
        let main: Main         // Overall air quality index (AQI).
        let components: Components // Concentrations of pollutants.
        let dt: Int            // Timestamp of the air quality data (Unix time).
    }

    /// A list of air quality records returned by the API.
    let list: [AirQuality]
}
