//
//  SkyBackgroundView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Time-based sky background that changes color throughout the day
struct SkyBackgroundView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
    
    var skyColors: [Color] {
        let hour = currentHour
        
        // Dawn (5-7 AM) - Warm pastel sunrise
        if hour >= 5 && hour < 7 {
            return [
                Color(red: 0.95, green: 0.85, blue: 0.75),  // Soft peach
                Color(red: 0.95, green: 0.90, blue: 0.85),  // Pale cream
                Color(red: 0.90, green: 0.95, blue: 0.92)   // Mint sky
            ]
        }
        // Day (7 AM - 5 PM) - Bright pastel blue
        else if hour >= 7 && hour < 17 {
            return [
                Color(red: 0.85, green: 0.92, blue: 0.96),  // Soft sky blue
                Color(red: 0.92, green: 0.96, blue: 0.97),  // Pale blue
                Color(red: 0.95, green: 0.97, blue: 0.96)   // Almost white blue
            ]
        }
        // Dusk (5-8 PM) - Warm pastel sunset
        else if hour >= 17 && hour < 20 {
            return [
                Color(red: 0.92, green: 0.85, blue: 0.90),  // Lavender pink
                Color(red: 0.95, green: 0.88, blue: 0.80),  // Peach glow
                Color(red: 0.95, green: 0.92, blue: 0.88)   // Warm cream
            ]
        }
        // Evening/Night (8 PM - 5 AM) - Soft evening pastels
        else {
            return [
                Color(red: 0.88, green: 0.90, blue: 0.95),  // Soft periwinkle
                Color(red: 0.92, green: 0.92, blue: 0.96),  // Pale lavender
                Color(red: 0.94, green: 0.94, blue: 0.96)   // Almost white purple
            ]
        }
    }
    
    var body: some View {
        LinearGradient(
            colors: skyColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentHour = Calendar.current.component(.hour, from: Date())
            }
        }
    }
}

#Preview {
    SkyBackgroundView()
}


