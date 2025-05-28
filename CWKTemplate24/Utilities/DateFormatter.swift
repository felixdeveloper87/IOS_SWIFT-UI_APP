//
//  DateFormatter.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import Foundation

/// A utility class providing various methods and predefined closures for converting
/// Unix timestamps into human-readable date formats.
///
/// This class centralises date formatting logic, ensuring consistency across the application
/// when dealing with different date representations. It supports common date styles,
/// such as short formats, 12-hour clocks, and custom formats.
class DateFormatterUtils {

    /// A shared `DateFormatter` instance for the default full format (`dd-MM-yyyy HH:mm:ss`).
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()

    /// A shared `DateFormatter` instance for short date formats (`dd/MM/yyyy`).
    static let shortDateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    /// A shared `DateFormatter` instance for time-only formats (`HH:mm:ss`).
    static let timeFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()

    /// A shared `DateFormatter` instance for custom ISO 8601 formats (`yyyy-MM-dd'T'HH:mm:ssZ`).
    static let customFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()

    /// Converts a Unix timestamp into a formatted date string.
    ///
    /// - Parameters:
    ///   - timestamp: The Unix timestamp (in seconds since 1970).
    ///   - format: The desired date format string.
    /// - Returns: A string representing the formatted date.
    static func formattedDate(from timestamp: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// Formats the current date into a string using the specified format.
    ///
    /// - Parameter format: The desired date format string.
    /// - Returns: A string representing the current date in the specified format.
    static func formattedCurrentDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }

    /// Converts a Unix timestamp into a date string using a predefined `DateFormatter.Style`.
    ///
    /// - Parameters:
    ///   - timestamp: The Unix timestamp (in seconds since 1970).
    ///   - style: The desired `DateFormatter.Style` (e.g., `.short`, `.medium`).
    /// - Returns: A string representing the formatted date.
    static func formattedDateWithStyle(from timestamp: Int, style: DateFormatter.Style) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: date)
    }

    /// Converts a Unix timestamp into a 12-hour clock time string.
    ///
    /// - Parameter timestamp: The Unix timestamp (in seconds since 1970).
    /// - Returns: A string representing the time in 12-hour format (e.g., `03:45 PM`).
    static func formattedDate12Hour(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

    /// Converts a Unix timestamp into a string showing the time (12-hour) and day of the week.
    ///
    /// - Parameter timestamp: The Unix timestamp (in seconds since 1970).
    /// - Returns: A string representing the time and abbreviated weekday (e.g., `03 PM Mon`).
    static func formattedDateWithDay(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a E"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
        return dateString
    }

    /// Converts a Unix timestamp into a string showing the full weekday name and day.
    ///
    /// - Parameter timestamp: The Unix timestamp (in seconds since 1970).
    /// - Returns: A string representing the full weekday name and day (e.g., `Monday 06`).
    static func formattedDateWithWeekdayAndDay(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }

    /// Converts a Unix timestamp into a string showing the date and time in a custom format.
    ///
    /// - Parameter timestamp: The Unix timestamp (in seconds since 1970).
    /// - Returns: A string representing the date and time (e.g., `6 Jan 2025 at 3 PM`).
    static func formattedDateTime(from timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy 'at' h a"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
