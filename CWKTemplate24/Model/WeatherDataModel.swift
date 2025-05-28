//
//  WeatherDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation

// MARK: - WeatherDataModel
/// Represents the root data model for weather information.
/// This structure is designed to decode weather data from a JSON response,
/// containing details such as the current, hourly, daily, and minutely weather forecasts.
struct WeatherDataModel: Codable, Identifiable {
    let id = UUID() // Unique identifier for SwiftUI compatibility.
    let lat, lon: Double // Latitude and longitude of the location.
    let timezone: String // The name of the timezone (e.g., "America/New_York").
    let timezoneOffset: Int // The offset in seconds from UTC.
    let current: Current // The current weather details.
    let minutely: [Minutely]? // Optional minute-by-minute forecast.
    let hourly: [Current] // Hourly weather forecast.
    let daily: [Daily] // Daily weather forecast.

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily
    }
}

// MARK: - Current
/// Represents the current weather or hourly forecast details.
struct Current: Codable, Identifiable {
    let id = UUID() // Unique identifier for SwiftUI compatibility.
    let dt: Int // The timestamp of the weather data.
    let sunrise, sunset: Int? // Sunrise and sunset times (optional).
    let temp, feelsLike: Double // Temperature and "feels like" temperature.
    let pressure, humidity: Int // Atmospheric pressure (hPa) and humidity (%).
    let dewPoint, uvi: Double // Dew point temperature and UV index.
    let clouds: Int // Cloudiness percentage.
    let visibility: Int? // Visibility in metres (optional).
    let windSpeed: Double // Wind speed in m/s.
    let windDeg: Int // Wind direction in degrees.
    let weather: [Weather] // Array of weather conditions (e.g., rain, snow).
    let windGust, pop: Double? // Wind gust speed and probability of precipitation (optional).
    let rain: Rain? // Rainfall volume in the last hour (optional).

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop, rain
    }
}

// MARK: - Rain
/// Represents rainfall details in the weather data.
struct Rain: Codable {
    let the1H: Double // Rainfall in the last hour (mm).

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
/// Represents individual weather conditions, such as "Rain" or "Clear".
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: Description
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Main
/// Enum representing the primary weather categories.
/// Provides a structured way to interpret weather conditions.
enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"
    case snow = "Snow"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
}

// MARK: - Description
/// Enum representing detailed weather descriptions.
/// Includes various levels of intensity for conditions like rain, snow, and thunderstorms.
enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    case thunderstormWithLightRain = "thunderstorm with light rain"
    case thunderstormWithRain = "thunderstorm with rain"
    case thunderstormWithHeavyRain = "thunderstorm with heavy rain"
    case lightThunderstorm = "light thunderstorm"
    case thunderstorm = "thunderstorm"
    case heavyThunderstorm = "heavy thunderstorm"
    case raggedThunderstorm = "ragged thunderstorm"
    case thunderstormWithLightDrizzle = "thunderstorm with light drizzle"
    case thunderstormWithDrizzle = "thunderstorm with drizzle"
    case thunderstormWithHeavyDrizzle = "thunderstorm with heavy drizzle"
    case heavyIntensityDrizzle = "heavy intensity drizzle"
    case lightIntensityDrizzleRain = "light intensity drizzle rain"
    case drizzleRain = "drizzle rain"
    case heavyIntensityDrizzleRain = "heavy intensity drizzle rain"
    case showerRainAndDrizzle = "shower rain and drizzle"
    case heavyShowerRainAndDrizzle = "heavy shower rain and drizzle"
    case showerDrizzle = "shower drizzle"
    case heavyIntensityRain = "heavy intensity rain"
    case veryHeavyRain = "very heavy rain"
    case extremeRain = "exteme rain"
    case freezingRain = "freezing rain"
    case lightIntensityShowerRain = "light intensity shower rain"
    case showerRain = "shower rain"
    case heavyIntensityShowerRain = "heavy intensity shower rain"
    case raggedShowerRain = "ragged shower rain"
    case lightSnow = "light snow"
    case snow = "snow"
    case heavySnow = "heavy snow"
    case sleet = "sleet"
    case lightShowerSleet = "light shower sleet"
    case showerSleet = "shower sleet"
    case lightRainAndSnow = "light rain and snow"
    case rainAndSnow = "rain and snow"
    case lightShowerSnow = "light shower snow"
    case showerSnow = "shower snow"
    case heavyShowerSnow = "heavy shower snow"
    case mist = "mist"
    case smoke = "smoke"
    case haze = "haze"
    case sandDustWhirls = "sand/dust whirls"
    case fog = "fog"
    case sand = "sand"
    case dust = "dust"
    case volcanicAsh = "volcanic ash"
    case squalls = "squalls"
    case tornado = "tornado"
    case fewClouds1125 = "few clouds: 11-25%"
    case scatteredClouds2550 = "scattered clouds: 25-50%"
    case brokenClouds5184 = "broken clouds: 51-84%"
    case overcastClouds85100 = "overcast clouds: 85-100%"
    case lightIntensityDrizzle = "light intensity drizzle"
    case unknown

    /// Decodes a description string, with a fallback for unknown values.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).lowercased() // Converter para minúsculas
        guard let description = Description(rawValue: value) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown description: \(value)"
            )
        }
        self = description
    }
}

// MARK: - Daily
/// Represents daily weather forecast details, including temperature and wind information.
struct Daily: Codable, Identifiable {
    let id = UUID() // Unique identifier for SwiftUI compatibility.
    let dt, sunrise, sunset, moonrise, moonset: Int // Timestamps for key events.
    let moonPhase: Double // Phase of the moon (0-1).
    let temp: Temp // Daily temperature details.
    let feelsLike: FeelsLike // Daily "feels like" temperatures.
    let pressure, humidity: Int // Atmospheric pressure and humidity.
    let dewPoint, windSpeed: Double // Dew point and wind speed.
    let windDeg: Int // Wind direction in degrees.
    let windGust: Double // Wind gust speed.
    let weather: [Weather] // Array of weather conditions.
    let clouds: Int // Cloudiness percentage.
    let pop: Double // Probability of precipitation.
    let rain: Double? // Rainfall volume in mm (optional).
    let uvi: Double // UV index.

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
}

// MARK: - FeelsLike
/// Represents "feels like" temperature readings for various times of the day.
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
/// Represents temperature readings for various times of the day.
struct Temp: Codable {
    let day, min, max, night, eve, morn: Double
}

// MARK: - Minutely
/// Represents minute-by-minute precipitation data.
struct Minutely: Codable {
    let dt: Int // Timestamp of the minute data.
    let precipitation: Double // Precipitation volume in mm.
}


