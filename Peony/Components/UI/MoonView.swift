//
//  MoonView.swift
//  Peony
//
//  Enhanced with realistic arc-based movement and improved details
//

import SwiftUI

/// Animated moon that moves across the night sky in a realistic arc pattern
struct MoonView: View {
    @Bindable var timeManager = TimeManager.shared
    @State private var glowIntensity: CGFloat = 0.3
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            // Calculate moon position based on actual time
            let position = calculateMoonPosition(screenWidth: screenWidth, screenHeight: screenHeight)
            
            ZStack {
                // Subtle outer glow (much smaller and softer)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(glowIntensity * 0.15),
                                Color(red: 0.92, green: 0.92, blue: 0.96).opacity(glowIntensity * 0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                // Inner glow (reduced)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(glowIntensity * 0.25),
                                Color(red: 0.96, green: 0.96, blue: 0.99).opacity(glowIntensity * 0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                
                // Moon body with enhanced gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.99, green: 0.99, blue: 1.0),
                                Color(red: 0.96, green: 0.96, blue: 0.98),
                                Color(red: 0.92, green: 0.92, blue: 0.96),
                                Color(red: 0.88, green: 0.88, blue: 0.93)
                            ],
                            center: .init(x: 0.35, y: 0.35),
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        // Enhanced crater details
                        ZStack {
                            // Large crater
                            Circle()
                                .fill(Color(red: 0.86, green: 0.86, blue: 0.91).opacity(0.5))
                                .frame(width: 12, height: 12)
                                .offset(x: -10, y: -8)
                            
                            // Medium craters
                            Circle()
                                .fill(Color(red: 0.88, green: 0.88, blue: 0.93).opacity(0.6))
                                .frame(width: 8, height: 8)
                                .offset(x: 12, y: 6)
                            
                            Circle()
                                .fill(Color(red: 0.87, green: 0.87, blue: 0.92).opacity(0.4))
                                .frame(width: 10, height: 10)
                                .offset(x: 5, y: -6)
                            
                            // Small craters
                            Circle()
                                .fill(Color(red: 0.89, green: 0.89, blue: 0.94).opacity(0.5))
                                .frame(width: 6, height: 6)
                                .offset(x: -5, y: 8)
                            
                            Circle()
                                .fill(Color(red: 0.88, green: 0.88, blue: 0.93).opacity(0.4))
                                .frame(width: 5, height: 5)
                                .offset(x: 8, y: -3)
                            
                            Circle()
                                .fill(Color(red: 0.87, green: 0.87, blue: 0.92).opacity(0.3))
                                .frame(width: 4, height: 4)
                                .offset(x: -8, y: 2)
                        }
                    )
                    .shadow(color: Color.white.opacity(0.3), radius: 20, x: 0, y: 0)
                    .shadow(color: Color(red: 0.9, green: 0.9, blue: 0.95).opacity(0.2), radius: 10, x: 0, y: 0)
            }
            .position(position)
            .onAppear {
                // Gentle glow pulsing (subtle)
                withAnimation(
                    .easeInOut(duration: 4.5)
                    .repeatForever(autoreverses: true)
                ) {
                    glowIntensity = 0.45
                }
            }
        }
    }
    
    /// Calculate moon position using arc-based movement
    private func calculateMoonPosition(screenWidth: CGFloat, screenHeight: CGFloat) -> CGPoint {
        guard let progress = timeManager.moonProgress else {
            // Moon not visible, return off-screen position
            return CGPoint(x: -100, y: -100)
        }

        // Moon travels in an arc across the night sky
        // Progress: 0.0 = moonrise (left), 0.5 = zenith (center), 1.0 = moonset (right)
        
        // Horizontal position (left to right)
        let horizontalProgress = progress
        let xPosition = screenWidth * 0.1 + (screenWidth * 0.8 * horizontalProgress)
        
        // Vertical position (wide upside-down U arc)
        let arcHeight = screenHeight * 0.25 // Taller arc for pronounced upside-down U (same as sun)
        let verticalProgress = sin(progress * .pi) // Creates arc from 0 to 1 and back to 0
        let yPosition = screenHeight * 0.70 - (arcHeight * verticalProgress)
        
        return CGPoint(x: xPosition, y: yPosition)
    }
}

#Preview("Night") {
    ZStack {
        Color.black.opacity(0.8)
        MoonView()
    }
    .ignoresSafeArea()
}
