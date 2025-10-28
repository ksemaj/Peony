//
//  GardenBackgroundView.swift
//  Peony
//
//  Integrated garden background with all atmospheric layers
//

import SwiftUI

/// Complete garden background with sky, celestial, clouds, stars, and lighting
struct GardenBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Layer 1: Sky background (seasonal gradients)
                SkyBackgroundView()
                
                // Layer 2: Star field (night only, behind celestial bodies)
                StarField()
                
                // Layer 3: Clouds (parallax layers)
                CloudLayer()
                
                // Layer 4: Sky area with celestial body (top 30%)
                VStack(spacing: 0) {
                    ZStack {
                        Color.clear
                        
                        // Sun or Moon with smooth transitions
                        CelestialView()
                            .offset(y: -50)
                    }
                    .frame(height: max(geometry.size.height * 0.30, 100))
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview("Spring Day") {
    GardenBackgroundView()
}

#Preview("Summer Dusk") {
    GardenBackgroundView()
}

#Preview("Fall Night") {
    GardenBackgroundView()
}

#Preview("Winter Dawn") {
    GardenBackgroundView()
}
