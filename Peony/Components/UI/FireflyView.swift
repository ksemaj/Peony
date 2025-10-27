//
//  FireflyView.swift
//  Peony
//
//  Enhanced with lighting awareness for dynamic glow intensity
//

import SwiftUI

/// Animated firefly particle that glows and moves randomly with lighting-aware visibility
struct FireflyView: View {
    let index: Int
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var glowIntensity: Double = 0.3
    @State private var trajectory: Double = 0
    @State private var timeManager = TimeManager.shared
    
    var body: some View {
        let lightingModifier = AmbientLighting.shared.getFaunaLightingModifier(timeManager: timeManager)
        
        ZStack {
            // Glow halo (enhanced in darkness)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.7).opacity(glowIntensity * lightingModifier.glow),
                            Color(red: 0.9, green: 0.85, blue: 0.5).opacity(glowIntensity * lightingModifier.glow * 0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
            
            // Firefly core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 1.0, blue: 0.8),
                            Color(red: 0.95, green: 0.9, blue: 0.6)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 4
                    )
                )
                .frame(width: 8, height: 8)
        }
        .opacity(lightingModifier.opacity) // Respond to lighting conditions
        .position(position)
        .blur(radius: 0.5) // Soft glow effect
        .onAppear {
            // Constrain to ground area (30-95% of screen height)
            let screenWidth = 400.0 // Approximate screen width
            let screenHeight = 900.0 // Approximate screen height
            let randomX = Double.random(in: 50...(screenWidth - 50))
            let randomY = Double.random(in: (screenHeight * 0.35)...(screenHeight * 0.90))
            position = CGPoint(x: randomX, y: randomY)
            trajectory = Double.random(in: 0...(2 * Double.pi))
            
            // Create unique animation for each firefly
            let glowVariation = Double.random(in: 0.2...0.6)
            
            // Make fireflies move in a figure-8 pattern (stay in ground area)
            withAnimation(
                .easeInOut(duration: Double.random(in: 8...15))
                .repeatForever(autoreverses: true)
            ) {
                position = CGPoint(
                    x: randomX + CGFloat(Double.random(in: -100...100)),
                    y: min(max(randomY + CGFloat(Double.random(in: -100...100)), screenHeight * 0.35), screenHeight * 0.90)
                )
            }
            
            withAnimation(
                .easeInOut(duration: Double.random(in: 1...2.5))
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = glowVariation
            }
        }
    }
}

/// Collection of fireflies for night ambiance
struct FireflyFieldView: View {
    let count: Int = 12 // Number of fireflies
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                FireflyView(index: i)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.8)
        FireflyFieldView()
    }
    .ignoresSafeArea()
}
