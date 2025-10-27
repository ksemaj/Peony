//
//  SunView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Animated sun that moves across the sky
struct SunView: View {
    @State private var sunPosition: Double = 0 // Animation value from 0 to 1
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.8).opacity(0.3),
                            Color(red: 1.0, green: 0.88, blue: 0.6).opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 30,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
            
            // Sun core
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 1.0, blue: 0.9),
                            Color(red: 1.0, green: 0.85, blue: 0.5)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(pulseScale)
                .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 0)
        }
        .offset(x: CGFloat(sunPosition * 600 - 300), y: -200) // Moves across sky
        .onAppear {
            // Continuous sun movement
            withAnimation(
                .linear(duration: 60) // Full cycle in 60 seconds
                .repeatForever(autoreverses: false)
            ) {
                sunPosition = 1.0
            }
            
            // Pulsing effect
            withAnimation(
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.1
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.2)
        SunView()
    }
    .ignoresSafeArea()
}


