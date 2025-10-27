//
//  MoonView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Animated moon that moves across the night sky
struct MoonView: View {
    @State private var moonPosition: Double = 0
    @State private var glowIntensity: CGFloat = 0.3
    
    var body: some View {
        ZStack {
            // Outer glow (softer than sun)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.95, green: 0.95, blue: 0.98).opacity(glowIntensity),
                            Color(red: 0.9, green: 0.9, blue: 0.95).opacity(glowIntensity * 0.5),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 25,
                        endRadius: 70
                    )
                )
                .frame(width: 140, height: 140)
            
            // Moon body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.98, green: 0.98, blue: 1.0),
                            Color(red: 0.9, green: 0.9, blue: 0.95),
                            Color(red: 0.85, green: 0.85, blue: 0.9)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 35
                    )
                )
                .frame(width: 70, height: 70)
                .overlay(
                    // Crater details
                    Group {
                        Circle()
                            .fill(Color(red: 0.85, green: 0.85, blue: 0.9).opacity(0.4))
                            .frame(width: 8, height: 8)
                            .offset(x: -8, y: -10)
                        Circle()
                            .fill(Color(red: 0.88, green: 0.88, blue: 0.93).opacity(0.5))
                            .frame(width: 6, height: 6)
                            .offset(x: 10, y: 5)
                        Circle()
                            .fill(Color(red: 0.86, green: 0.86, blue: 0.91).opacity(0.3))
                            .frame(width: 10, height: 10)
                            .offset(x: 5, y: -5)
                    }
                )
                .shadow(color: .white.opacity(0.2), radius: 15, x: 0, y: 0)
        }
        .offset(x: CGFloat(moonPosition * 600 - 300), y: -150) // Moves across sky
        .onAppear {
            // Continuous moon movement (slower than sun)
            withAnimation(
                .linear(duration: 80) // Full cycle in 80 seconds
                .repeatForever(autoreverses: false)
            ) {
                moonPosition = 1.0
            }
            
            // Gentle glow pulsing
            withAnimation(
                .easeInOut(duration: 4)
                .repeatForever(autoreverses: true)
            ) {
                glowIntensity = 0.5
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.8)
        MoonView()
    }
    .ignoresSafeArea()
}


