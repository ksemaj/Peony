//
//  StarField.swift
//  Peony
//
//  Twinkling star field for night sky with seasonal visibility
//

import SwiftUI

/// Individual star with twinkling animation and sparkle effect
struct Star: View {
    let index: Int
    let brightness: Double
    let size: CGFloat
    
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0
    @State private var sparkleIntensity: Double = 0.0
    @State private var rotation: Double = 0.0
    
    var body: some View {
        ZStack {
            // Base star with gradient glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white,
                            .white.opacity(0.8),
                            .white.opacity(0.3),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 2
                    )
                )
                .frame(width: size * 2, height: size * 2)
                .opacity(opacity * brightness)
            
            // Center bright point
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .opacity(opacity * brightness * (0.5 + sparkleIntensity * 0.5))
            
            // Sparkle effect - small bright points that rotate
            ForEach(0..<4, id: \.self) { sparkleIndex in
                Circle()
                    .fill(Color.white)
                    .frame(width: size * 0.8, height: size * 0.8)
                    .offset(x: size * 1.5 * cos(rotation + Double(sparkleIndex) * .pi / 2),
                           y: size * 1.5 * sin(rotation + Double(sparkleIndex) * .pi / 2))
                    .opacity(sparkleIntensity * brightness * 0.6)
            }
        }
        .scaleEffect(scale)
        .drawingGroup() // Crisper rendering
        .onAppear {
            // Staggered appearance
            let delay = Double.random(in: 0...2)
            
            // Twinkling animation with random timing
            let twinkleDuration = Double.random(in: 1.5...4.0)
            let scaleVariation = Double.random(in: 0.05...0.15)
            
            // Fade in
            withAnimation(.easeIn(duration: 1.0).delay(delay)) {
                opacity = 1.0
            }
            
            // Start twinkling
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(
                    .easeInOut(duration: twinkleDuration)
                    .repeatForever(autoreverses: true)
                ) {
                    opacity = Double.random(in: 0.4...1.0)
                    scale = 1.0 + scaleVariation
                    sparkleIntensity = Double.random(in: 0.5...1.0)
                }
            }
            
            // Sparkle rotation animation (slow, subtle)
            let rotationDuration = Double.random(in: 8...15)
            withAnimation(
                .linear(duration: rotationDuration)
                .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

/// Complete star field system for night sky
struct StarField: View {
    @Bindable var timeManager = TimeManager.shared
    @State private var stars: [(position: CGPoint, brightness: Double, size: CGFloat)] = []
    @State private var animationTrigger: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if AppConfig.Environment.enableStarField && timeManager.isNighttime {
                    ForEach(stars.indices, id: \.self) { index in
                        Star(
                            index: index,
                            brightness: stars[index].brightness,
                            size: stars[index].size
                        )
                        .position(stars[index].position)
                    }
                }
            }
            .opacity(starFieldOpacity)
            .onAppear {
                generateStars(in: geometry.size)
            }
            .onChange(of: timeManager.currentSeason) { _, _ in
                withAnimation(.easeInOut(duration: 1.5)) {
                    generateStars(in: geometry.size)
                }
            }
            .onChange(of: geometry.size) { oldSize, newSize in
                // Regenerate stars if size changed significantly or if no stars exist
                let sizeChangeThreshold: CGFloat = 50
                let widthChanged = abs(newSize.width - oldSize.width) > sizeChangeThreshold
                let heightChanged = abs(newSize.height - oldSize.height) > sizeChangeThreshold

                if stars.isEmpty || widthChanged || heightChanged {
                    // Only animate if stars already exist (not initial generation)
                    if !stars.isEmpty && (widthChanged || heightChanged) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            generateStars(in: newSize)
                        }
                    } else {
                        generateStars(in: newSize)
                    }
                }
            }
        }
    }
    
    /// Overall star field opacity based on time of day
    private var starFieldOpacity: Double {
        if !timeManager.isNighttime {
            return 0.0
        }

        // Show stars during night stages only
        switch timeManager.timeOfDay {
        case .evening, .midnight:
            return 1.0 * seasonalVisibility
        default:
            return 0.0
        }
    }
    
    /// Seasonal visibility multiplier
    private var seasonalVisibility: Double {
        switch timeManager.currentSeason {
        case .spring:
            return AppConfig.Environment.StarConfig.springVisibility
        case .summer:
            return AppConfig.Environment.StarConfig.summerVisibility
        case .fall:
            return AppConfig.Environment.StarConfig.fallVisibility
        case .winter:
            return AppConfig.Environment.StarConfig.winterVisibility
        }
    }
    
    /// Number of stars based on season
    private var starCount: Int {
        let baseCount = 80
        return Int(Double(baseCount) * seasonalVisibility)
    }
    
    /// Generate random star positions with varied properties
    private func generateStars(in size: CGSize) {
        var newStars: [(position: CGPoint, brightness: Double, size: CGFloat)] = []

        // Place stars in top 60% of screen (sky area), avoiding top UI elements
        let topOffset: CGFloat = 150 // Avoid notch/status bar/buttons area
        let skyHeight = size.height * 0.60

        // Ensure topOffset doesn't exceed skyHeight (would cause crash)
        let validTopOffset = min(topOffset, skyHeight * 0.2) // Use 20% of sky height as minimum
        let validSkyHeight = max(skyHeight, topOffset + 100) // Ensure at least 100px range

        for _ in 0..<starCount {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: validTopOffset...validSkyHeight)
            
            // Varied star properties
            let brightness = Double.random(in: 0.4...1.0)
            
            // Star size based on brightness (brighter = slightly larger)
            let baseSize: CGFloat = 1.0
            let sizeVariation = CGFloat(brightness * 0.5)
            let size = baseSize + sizeVariation
            
            newStars.append((
                position: CGPoint(x: x, y: y),
                brightness: brightness,
                size: size
            ))
        }
        
        stars = newStars
    }
}

#Preview("Night Sky with Stars") {
    ZStack {
        // Night sky gradient
        LinearGradient(
            colors: [
                Color(red: 0.75, green: 0.78, blue: 0.88),
                Color(red: 0.82, green: 0.85, blue: 0.92),
                Color(red: 0.88, green: 0.90, blue: 0.95)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        StarField()
    }
    .ignoresSafeArea()
}

