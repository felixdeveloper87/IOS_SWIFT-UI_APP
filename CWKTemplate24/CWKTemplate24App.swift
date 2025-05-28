//
//  WeatherIconHelper.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 26/11/2024.
//

import SwiftUI
import SwiftData

@main
struct LeCWKTemplate24App: App {
    // MARK:  create a StateObject - weatherMapPlaceViewModel and inject it as an environmentObject.
    @StateObject private var weatherMapPlaceViewModel = WeatherMapPlaceViewModel()


    var body: some Scene {
        WindowGroup {
            NavBarView()
                .environmentObject(weatherMapPlaceViewModel)
        }
    }
}
