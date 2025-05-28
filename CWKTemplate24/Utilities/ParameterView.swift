//
//  ParameterView.swift
//  Leandro_CWKTemplate24
//
//  Created by Leandro Felix on 23/11/2024.
//

import SwiftUI

/// A SwiftUI view for displaying a parameter with an associated image and value.
///
/// This view is designed to present a small card-like component, which can display a visual
/// representation (via an image) alongside a numerical value. It is styled with a grey background
/// and rounded corners, making it suitable for use in dashboards or parameterised displays.
struct ParameterView: View {
    /// The numerical value to display. If `nil`, the value defaults to `0.00`.
    let value: Double?
    
    /// The name of the image resource to display.
    let imageName: String

    var body: some View {
        VStack {
            // Displays the image corresponding to `imageName`.
            Image(imageName)
                .resizable()              // Ensures the image can scale.
                .frame(width: 70, height: 70) // Fixed size for consistency in layout.
            
            // Displays the numerical value formatted to two decimal places.
            Text("\(String(format: "%.2f", value ?? 0))")
                .font(.subheadline)       // Styling for the text label.
        }
        .background(Color(.systemGray3).opacity(1)) // Sets a grey background.
        .cornerRadius(3)                 // Adds slight rounding to the corners.
        .frame(width: 70)                // Constrains the view width to ensure uniformity.
    }
}
