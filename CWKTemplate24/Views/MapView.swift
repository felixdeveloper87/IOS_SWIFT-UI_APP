//
//  MapView.swift
//  CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI
import MapKit

/// A view that displays a map with attractions and supports zooming and custom annotations.
///
/// This view integrates a map centred on a selected location, displays tourist attractions as annotations,
/// and provides a list of the top five nearby attractions. Users can interact with the map to zoom in or out.
struct MapView: View {
    /// The environment object used to manage weather and location data.
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    /// The region displayed on the map, including its centre and zoom level.
    @State private var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // Default to London
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    /// A list of place annotations to display on the map.
    @State private var placeAnnotations: [PlaceAnnotationDataModel] = []

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background image for visual enhancement.
            Image("sky")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.7)

            VStack(spacing: 0) {
                ZStack {
                    // The map displaying annotations.
                    Map(coordinateRegion: $coordinateRegion, annotationItems: placeAnnotations) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Text(place.name)
                                    .font(.caption)
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .frame(height: UIScreen.main.bounds.height * 0.5)

                    // Zoom controls positioned at the bottom-right corner.
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: zoomIn) {
                                    Image(systemName: "plus.magnifyingglass")
                                        .font(.largeTitle)
                                        .padding()
                                        .background(Color.white.opacity(0.8))
                                        .clipShape(Circle())
                                }

                                Button(action: zoomOut) {
                                    Image(systemName: "minus.magnifyingglass")
                                        .font(.largeTitle)
                                        .padding()
                                        .background(Color.white.opacity(0.8))
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                        }
                    }
                }
                .onAppear {
                    searchAttractions()
                }
                .onChange(of: weatherMapPlaceViewModel.currentLocation) { newLocation in
                    if let loc = newLocation {
                        coordinateRegion.center = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
                        searchAttractions()
                    }
                }

                // List of attractions displayed below the map.
                VStack(alignment: .leading, spacing: 10) {
                    Text("Top 5 Attractions")
                        .font(.headline)
                        .padding(.top, 10)

                    if placeAnnotations.isEmpty {
                        Text("Loading attractions...")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(placeAnnotations) { place in
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.headline)
                                Text(place.name)
                                    .font(.body)
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // MARK: - Helper Functions

    /// Searches for nearby attractions and updates the annotations on the map.
    ///
    /// This function uses `MKLocalSearch` to find places of interest within the current map region.
    private func searchAttractions() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Tourist Attractions"
        request.region = coordinateRegion

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error fetching attractions: \(String(describing: error))")
                return
            }

            let top5 = response.mapItems.prefix(5) // Select the top 5 attractions.
            let mappedPlaces = top5.compactMap { item -> PlaceAnnotationDataModel? in
                guard let name = item.placemark.name else { return nil }
                return PlaceAnnotationDataModel(name: name, coordinate: item.placemark.coordinate)
            }

            DispatchQueue.main.async {
                self.placeAnnotations = mappedPlaces
            }
        }
    }

    /// Zooms in on the map by reducing the span.
    private func zoomIn() {
        coordinateRegion.span = MKCoordinateSpan(
            latitudeDelta: max(coordinateRegion.span.latitudeDelta / 2, 0.002),
            longitudeDelta: max(coordinateRegion.span.longitudeDelta / 2, 0.002)
        )
    }

    /// Zooms out on the map by increasing the span.
    private func zoomOut() {
        coordinateRegion.span = MKCoordinateSpan(
            latitudeDelta: min(coordinateRegion.span.latitudeDelta * 2, 180),
            longitudeDelta: min(coordinateRegion.span.longitudeDelta * 2, 180)
        )
    }
}

#Preview {
    MapView()
        .environmentObject(WeatherMapPlaceViewModel())
}
