//
//  StarField.swift
//  Peony
//
//  Twinkling star field for night sky with seasonal visibility
//

import SwiftUI

/// Individual star with twinkling animation
struct Star: View {
    let index: Int
    let brightness: Double
    let size: CGFloat
    
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: size, height: size)
            .opacity(opacity * brightness)
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
                        opacity = Double.random(in: 0.3...1.0)
                        scale = 1.0 + scaleVariation
                    }
                }
            }
    }
}

/// Complete star field system for night sky
struct StarField: View {
    @State private var timeManager = TimeManager.shared
    @State private var stars: [(position: CGPoint, brightness: Double, size: CGFloat)] = []
    
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
                generateStars(in: geometry.size)
            }
            .onChange(of: geometry.size) { oldSize, newSize in
                if stars.isEmpty { // Only generate if stars haven't been generated yet
                    generateStars(in: newSize)
                }
            }
        }
    }
    
    /// Overall star field opacity based on time of day
    private var starFieldOpacity: Double {
        if !timeManager.isNighttime {
            return 0.0
        }
        
        // Fade in/out during twilight
        switch timeManager.timeOfDay {
        case .dusk:
            // Fade in during dusk (inverse of twilight opacity)
            return 1.0 - timeManager.twilightOpacity
        case .dawn:
            // Fade out during dawn
            return 1.0 - timeManager.twilightOpacity
        case .night:
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
        
        // Only place stars in top 40% of screen (sky area)
        let skyHeight = size.height * 0.40
        
        for _ in 0..<starCount {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...skyHeight)
            
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

