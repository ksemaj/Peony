//
//  SunView.swift
//  Peony
//
//  Enhanced with realistic arc-based movement and seasonal variations
//

import SwiftUI

/// Animated sun that moves across the sky in a realistic arc pattern
struct SunView: View {
    @State private var timeManager = TimeManager.shared
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            // Calculate sun position based on actual time
            let position = calculateSunPosition(screenWidth: screenWidth, screenHeight: screenHeight)
            
            ZStack {
                // Outer glow (enhanced)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1.0, green: 0.98, blue: 0.85).opacity(0.4),
                                Color(red: 1.0, green: 0.92, blue: 0.65).opacity(0.2),
                                Color(red: 1.0, green: 0.88, blue: 0.5).opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 90
                        )
                    )
                    .frame(width: 180, height: 180)
                
                // Mid glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1.0, green: 0.95, blue: 0.8).opacity(0.5),
                                Color(red: 1.0, green: 0.88, blue: 0.6).opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 25,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                // Sun core with enhanced gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1.0, green: 1.0, blue: 0.95),
                                Color(red: 1.0, green: 0.98, blue: 0.85),
                                Color(red: 1.0, green: 0.90, blue: 0.6),
                                Color(red: 1.0, green: 0.85, blue: 0.5)
                            ],
                            center: .init(x: 0.4, y: 0.4),
                            startRadius: 0,
                            endRadius: 45
                        )
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(pulseScale)
                    .shadow(color: Color(red: 1.0, green: 0.9, blue: 0.5).opacity(0.6), radius: 25, x: 0, y: 0)
                    .shadow(color: Color.yellow.opacity(0.4), radius: 15, x: 0, y: 0)
            }
            .position(position)
            .onAppear {
                // Gentle pulsing effect
                withAnimation(
                    .easeInOut(duration: 3.5)
                    .repeatForever(autoreverses: true)
                ) {
                    pulseScale = 1.08
                }
            }
        }
    }
    
    /// Calculate sun position using arc-based movement
    private func calculateSunPosition(screenWidth: CGFloat, screenHeight: CGFloat) -> CGPoint {
        guard let progress = timeManager.sunProgress else {
            // Sun not visible, return off-screen position
            return CGPoint(x: -100, y: -100)
        }
        
        // Sun travels in an arc across the sky
        // Progress: 0.0 = sunrise (left), 0.5 = zenith (center), 1.0 = sunset (right)
        
        // Horizontal position (left to right)
        let horizontalProgress = progress
        let xPosition = screenWidth * 0.1 + (screenWidth * 0.8 * horizontalProgress)
        
        // Vertical position (arc shape using sine function)
        // Arc height varies by season
        let arcHeight = getSeasonalArcHeight(screenHeight: screenHeight)
        let verticalProgress = sin(progress * .pi) // Creates arc from 0 to 1 and back to 0
        let yPosition = screenHeight * 0.55 - (arcHeight * verticalProgress)
        
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    /// Get arc height based on season (higher in summer, lower in winter)
    private func getSeasonalArcHeight(screenHeight: CGFloat) -> CGFloat {
        let baseHeight = screenHeight * 0.25
        
        switch timeManager.currentSeason {
        case .spring:
            return baseHeight * 0.9
        case .summer:
            return baseHeight * 1.1 // Higher arc in summer
        case .fall:
            return baseHeight * 0.95
        case .winter:
            return baseHeight * 0.8 // Lower arc in winter
        }
    }
}

#Preview("Daytime") {
    ZStack {
        Color.blue.opacity(0.2)
        SunView()
    }
    .ignoresSafeArea()
}
