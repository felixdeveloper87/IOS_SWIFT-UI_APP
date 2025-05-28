# ☀️ SwiftWeather – Advanced Weather App in SwiftUI

🏅 *Developed by Leandro Felix – University of Westminster (2024)*  
📚 *Educational project for the SwiftUI module*  
🎯 **Awarded: 96% (First Class Honours)**

SwiftWeather is a beautifully crafted weather application built entirely with **SwiftUI**, featuring modular architecture, live data from external APIs, and a clean, modern design. The app displays comprehensive weather information, including temperature, air quality, forecasts, and more — with full support for light and dark mode.

---

## 🌦️ Features

- 📍 **Location-Aware Forecast** – Automatic geolocation with map-based annotations
- 🌤️ **Current, Hourly & Daily Forecasts** – Clean separation of each view
- 💨 **Air Quality Index (AQI)** – Shown with real-time parameter data
- 🗺️ **Interactive Weather Map** – Annotated places with weather overlays
- 📅 **Visited Places Tracking** – User’s weather history by location
- 🎨 **Custom Icons & UI** – Built-in helper to select appropriate weather visuals

---

## 🧠 Architecture Overview

This project uses a clean MVVM-inspired modular structure:

SwiftWeather/
├── Assets.xcassets/
├── Model/ # All data models
│ ├── AirDataModel.swift
│ ├── LocationModel.swift
│ ├── PlaceAnnotationDataModel.swift
│ └── WeatherDataModel.swift
│
├── Utilities/ # Date, icon, and parameter helpers
│ ├── DateFormatter.swift
│ ├── ParameterView.swift
│ └── WeatherIconHelper.swift
│
├── ViewModel/ # View-specific data logic
│ └── WeatherMapPlaceViewModel.swift
│
├── Views/ # UI components and screens
│ ├── AirQualityView.swift
│ ├── CurrentWeatherView.swift
│ ├── DailyWeatherView.swift
│ ├── ForecastWeatherView.swift
│ ├── HeaderView.swift
│ ├── HourlyWeatherView.swift
│ ├── MapView.swift
│ ├── NavBarView.swift
│ └── VisitedPlacesView.swift
│
└── Leandro_CWKTemplate24App.swift # App entry point


---

## 🌍 API Integration

You can connect this app to either:

- [OpenWeatherMap API](https://openweathermap.org/api)  
- OR Apple’s WeatherKit (requires entitlements and iCloud)

Example setup for OpenWeatherMap:

```swift
let apiKey = "YOUR_API_KEY_HERE"
🔒 Your key should be stored securely in a config file or Keychain for production.

📱 Requirements
✅ Xcode 14+

✅ iOS 16.0+

✅ Swift 5.7+

❌ No UIKit or Storyboard — 100% SwiftUI!

🧪 Learning Outcomes
Using SwiftUI declarative UI and modifiers

Building custom reusable components (HeaderView, NavBarView, etc.)

Implementing MVVM structure in Swift

API consumption with URLSession and Codable

Date formatting, icons and dynamic visual representation

🚀 Getting Started

git clone https://github.com/SeuUsuario/SwiftWeather.git
open SwiftWeather.xcodeproj
Run the app in a Simulator or on a physical device. Set your API key before building.

📜 License
This project is for educational use only and not intended for commercial distribution.
© 2024 Leandro Felix