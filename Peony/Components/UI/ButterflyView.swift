//
//  ButterflyView.swift
//  Peony
//
//  Enhanced with lighting awareness for dynamic opacity
//

import SwiftUI

/// Animated butterfly with fluttering wings and lighting-aware visibility
struct ButterflyView: View {
    let index: Int
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var wingAngle: Double = 0
    @Bindable var timeManager = TimeManager.shared
    
    var body: some View {
        let lightingModifier = AmbientLighting.shared.getFaunaLightingModifier(timeManager: timeManager)
        
        ZStack {
            // Butterfly body
            Capsule()
                .fill(Color(red: 0.3, green: 0.2, blue: 0.1))
                .frame(width: 8, height: 12)
            
            // Upper wings
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.9, green: 0.7, blue: 0.3),
                            Color(red: 0.95, green: 0.8, blue: 0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 16, height: 10)
                .rotationEffect(.degrees(wingAngle))
                .offset(x: -4, y: -2)
            
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.9, green: 0.7, blue: 0.3),
                            Color(red: 0.95, green: 0.8, blue: 0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 16, height: 10)
                .rotationEffect(.degrees(-wingAngle))
                .offset(x: 4, y: -2)
            
            // Lower wings
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.6, blue: 0.25),
                            Color(red: 0.9, green: 0.7, blue: 0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 12, height: 8)
                .rotationEffect(.degrees(wingAngle * 0.7))
                .offset(x: -3, y: 3)
            
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.6, blue: 0.25),
                            Color(red: 0.9, green: 0.7, blue: 0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 12, height: 8)
                .rotationEffect(.degrees(-wingAngle * 0.7))
                .offset(x: 3, y: 3)
        }
        .opacity(lightingModifier.opacity) // Respond to lighting conditions
        .position(position)
        .onAppear {
            // Constrain to ground area (30-95% of screen height)
            let screenWidth = 400.0 // Approximate screen width
            let screenHeight = 900.0 // Approximate screen height
            let randomX = Double.random(in: 50...(screenWidth - 50))
            let randomY = Double.random(in: (screenHeight * 0.35)...(screenHeight * 0.85))
            position = CGPoint(x: randomX, y: randomY)
            
            // Wing fluttering animation
            withAnimation(
                .easeInOut(duration: 0.15)
                .repeatForever(autoreverses: true)
            ) {
                wingAngle = 25
            }
            
            // Flight pattern (stay in ground area)
            let duration = Double.random(in: 20...35)
            withAnimation(
                .linear(duration: duration)
                .repeatForever(autoreverses: false)
            ) {
                position = CGPoint(
                    x: randomX + CGFloat(Double.random(in: -150...150)),
                    y: min(max(randomY + CGFloat(Double.random(in: -80...80)), screenHeight * 0.35), screenHeight * 0.85)
                )
            }
        }
    }
}

/// Collection of butterflies for daytime ambiance
struct ButterflyFlockView: View {
    let count: Int = 3 // Number of butterflies
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                ButterflyView(index: i)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.2)
        ButterflyFlockView()
    }
    .ignoresSafeArea()
}
