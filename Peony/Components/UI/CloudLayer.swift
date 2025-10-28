//
//  CloudLayer.swift
//  Peony
//
//  Parallax cloud system with seasonal density variations
//

import SwiftUI

/// Individual cloud shape with customizable properties
struct Cloud: View {
    let size: CGSize
    let opacity: Double
    
    var body: some View {
        ZStack {
            // Main cloud body (3 overlapping circles)
            Circle()
                .fill(Color.white.opacity(opacity))
                .frame(width: size.width * 0.5, height: size.width * 0.4)
                .offset(x: -size.width * 0.15, y: 0)
            
            Circle()
                .fill(Color.white.opacity(opacity))
                .frame(width: size.width * 0.6, height: size.width * 0.5)
                .offset(x: 0, y: -size.height * 0.1)
            
            Circle()
                .fill(Color.white.opacity(opacity))
                .frame(width: size.width * 0.45, height: size.width * 0.35)
                .offset(x: size.width * 0.15, y: size.height * 0.05)
        }
        .blur(radius: 3)
    }
}

/// Single animated cloud that drifts across the screen
struct DriftingCloud: View {
    let index: Int
    let layerDepth: Int // 1 = far, 2 = mid, 3 = near
    let opacity: Double
    
    @State private var xOffset: CGFloat = 0
    @State private var yPosition: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let cloudSize = calculateCloudSize(for: layerDepth, screenWidth: geometry.size.width)
            
            Cloud(size: cloudSize, opacity: opacity * layerOpacity)
                .position(
                    x: xOffset,
                    y: yPosition
                )
                .onAppear {
                    // Random starting position - on level with "my garden" text for layered effect
                    // Cloud's vertical position adds more randomness
                    let baseY = CGFloat.random(in: (geometry.size.height * 0.05)...(geometry.size.height * 0.35))
                    let wiggle = CGFloat.random(in: -10...10)
                    yPosition = baseY + wiggle
                    
                    // Start off-screen with random entry point for more variety
                    let startOffset = CGFloat.random(in: -100...100)
                    xOffset = -cloudSize.width + startOffset
                    
                    // Calculate drift speed based on depth (farther = slower)
                    let duration = baseDuration * depthSpeedMultiplier
                    
                    // Add more randomization to prevent perfect synchronization
                    let randomDelay = Double.random(in: 0...(duration * 0.5))
                    
                    // Animate cloud drifting across screen
                    withAnimation(
                        .linear(duration: duration)
                        .repeatForever(autoreverses: false)
                        .delay(randomDelay)
                    ) {
                        xOffset = geometry.size.width + cloudSize.width
                    }
                }
        }
    }
    
    private var layerOpacity: Double {
        switch layerDepth {
        case 1: return 0.4  // Far layer - most transparent
        case 2: return 0.6  // Mid layer
        case 3: return 0.8  // Near layer - most opaque
        default: return 0.5
        }
    }
    
    private var baseDuration: Double {
        120.0 // Base time for clouds to cross screen
    }
    
    private var depthSpeedMultiplier: Double {
        switch layerDepth {
        case 1: return 1.8  // Slow (far away)
        case 2: return 1.3  // Medium
        case 3: return 1.0  // Fast (close)
        default: return 1.5
        }
    }
    
    private func calculateCloudSize(for depth: Int, screenWidth: CGFloat) -> CGSize {
        let baseWidth = screenWidth * 0.15
        
        switch depth {
        case 1: return CGSize(width: baseWidth * 0.7, height: baseWidth * 0.35)  // Small (far)
        case 2: return CGSize(width: baseWidth * 1.0, height: baseWidth * 0.5)   // Medium
        case 3: return CGSize(width: baseWidth * 1.3, height: baseWidth * 0.65)  // Large (near)
        default: return CGSize(width: baseWidth, height: baseWidth * 0.5)
        }
    }
}

/// Complete cloud layer system with multiple parallax depths
struct CloudLayer: View {
    @Bindable var timeManager = TimeManager.shared
    
    var body: some View {
        ZStack {
            if AppConfig.Environment.enableDynamicClouds {
                // Far layer (slowest, smallest, most transparent)
                ForEach(0..<cloudCount(for: 1), id: \.self) { index in
                    DriftingCloud(index: index, layerDepth: 1, opacity: seasonalOpacity)
                }
                
                // Mid layer
                ForEach(0..<cloudCount(for: 2), id: \.self) { index in
                    DriftingCloud(index: index, layerDepth: 2, opacity: seasonalOpacity)
                }
                
                // Near layer (fastest, largest, most opaque)
                ForEach(0..<cloudCount(for: 3), id: \.self) { index in
                    DriftingCloud(index: index, layerDepth: 3, opacity: seasonalOpacity)
                }
            }
        }
    }
    
    /// Get cloud count per layer based on seasonal density
    private func cloudCount(for layer: Int) -> Int {
        let density = seasonalDensity
        let baseCount: Int
        
        switch layer {
        case 1: baseCount = 2  // Far layer - fewer clouds
        case 2: baseCount = 3  // Mid layer
        case 3: baseCount = 2  // Near layer
        default: baseCount = 2
        }
        
        return Int(Double(baseCount) * density)
    }
    
    /// Get seasonal cloud density multiplier
    private var seasonalDensity: Double {
        switch timeManager.currentSeason {
        case .spring:
            return AppConfig.Environment.CloudConfig.springDensity
        case .summer:
            return AppConfig.Environment.CloudConfig.summerDensity
        case .fall:
            return AppConfig.Environment.CloudConfig.fallDensity
        case .winter:
            return AppConfig.Environment.CloudConfig.winterDensity
        }
    }
    
    /// Seasonal cloud opacity (visible during day, hidden at night)
    private var seasonalOpacity: Double {
        if timeManager.isNighttime {
            return 0.0 // Completely hidden at night
        } else {
            return 1.0
        }
    }
}

#Preview("Daytime Clouds") {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.92, blue: 0.96),
                Color(red: 0.92, green: 0.96, blue: 0.97)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        CloudLayer()
    }
    .ignoresSafeArea()
}

