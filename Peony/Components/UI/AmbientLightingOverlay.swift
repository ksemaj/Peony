//
//  AmbientLightingOverlay.swift
//  Peony
//
//  Translucent overlay that applies dynamic lighting effects to the garden
//

import SwiftUI

/// Overlay that applies time-based lighting effects to garden scene
struct AmbientLightingOverlay: View {
    @Bindable var timeManager = TimeManager.shared
    
    var body: some View {
        let lighting = AmbientLighting.shared.getCurrentLighting(timeManager: timeManager)
        
        ZStack {
            // Very subtle tint overlay (only during extreme conditions)
            if lighting.brightness < 0.3 {
                // Only darken during deep night (pre-dawn/night)
                Color.black
                    .opacity((1.0 - lighting.brightness) * 0.15)
                    .ignoresSafeArea()
                    .blendMode(.multiply)
            }
        }
        .allowsHitTesting(false) // Don't intercept touch events
    }
}

#Preview("Day") {
    ZStack {
        Color.blue.opacity(0.3)
        
        Text("Daytime Garden")
            .font(.largeTitle)
        
        AmbientLightingOverlay()
    }
}

#Preview("Night") {
    ZStack {
        Color.purple.opacity(0.3)
        
        Text("Nighttime Garden")
            .font(.largeTitle)
        
        AmbientLightingOverlay()
    }
}

