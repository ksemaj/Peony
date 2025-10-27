//
//  GardenBackgroundView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Fixed garden background with sky and celestial elements
struct GardenBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Sky background
                SkyBackgroundView()
                
                // Sky area (top 30%)
                VStack(spacing: 0) {
                    ZStack {
                        Color.clear
                        
                        // Sun or Moon
                        CelestialView()
                            .offset(y: -50)
                    }
                    .frame(height: geometry.size.height * 0.30)
                    
                    Spacer()
                }
                
                // All decorative elements hidden for redesign
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    GardenBackgroundView()
}

