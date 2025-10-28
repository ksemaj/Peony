//
//  RainDropletsAnimation.swift
//  Peony
//
//  Created for smooth rain droplet animation during watering
//

import SwiftUI

/// Smooth rain droplets animation that falls from top of screen
struct RainDropletsAnimation: View {
    @State private var animate = false
    
    // Configuration
    private let dropletCount = 50
    private let duration: Double = 2.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<dropletCount, id: \.self) { index in
                    WaterDroplet(
                        index: index,
                        totalDroplets: dropletCount,
                        screenWidth: geometry.size.width,
                        screenHeight: geometry.size.height,
                        duration: duration
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
        .onAppear {
            animate = true
        }
    }
}

/// Individual water droplet that falls from top to bottom
private struct WaterDroplet: View {
    let index: Int
    let totalDroplets: Int
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let duration: Double
    
    @State private var yProgress: CGFloat = 0
    @State private var opacity: Double = 0
    
    // Random offsets for natural rain pattern
    private let xPosition: CGFloat
    private let delay: Double
    private let speed: Double
    private let dropletSize: CGFloat
    
    init(index: Int, totalDroplets: Int, screenWidth: CGFloat, screenHeight: CGFloat, duration: Double) {
        self.index = index
        self.totalDroplets = totalDroplets
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.duration = duration
        
        // Create variation for natural rain using index-based seed
        let seed = UInt64(index)
        var rng1 = SeededRandomGenerator(seed: seed)
        var rng2 = SeededRandomGenerator(seed: seed + 1000)
        var rng3 = SeededRandomGenerator(seed: seed + 2000)
        var rng4 = SeededRandomGenerator(seed: seed + 3000)
        
        // Randomly place droplets across full screen width
        self.xPosition = rng1.random(in: 0...screenWidth)
        self.delay = rng2.random(in: 0...1.0)
        self.speed = rng3.random(in: 0.7...1.3)
        self.dropletSize = rng4.random(in: 18...28)
    }
    
    // Calculate y position based on progress
    private var yPosition: CGFloat {
        return -50 + yProgress * (screenHeight + 100)
    }
    
    var body: some View {
        Image(systemName: "drop.fill")
            .font(.system(size: dropletSize))
            .foregroundColor(.blue.opacity(0.6))
            .opacity(opacity)
            .frame(width: 50, height: 50)
            .position(x: xPosition, y: yPosition)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        // Fade in quickly
        withAnimation(.easeIn(duration: 0.3).delay(delay)) {
            opacity = 1.0
        }
        
        // Animate falling
        withAnimation(.linear(duration: duration * speed).delay(delay)) {
            yProgress = 1.0
        }
        
        // Fade out near the bottom
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + (duration * speed) - 0.3) {
            withAnimation(.easeOut(duration: 0.3)) {
                opacity = 0
            }
        }
    }
}

/// Simple seeded random number generator for consistent random values
private struct SeededRandomGenerator {
    private let initialState: UInt64
    private var currentState: UInt64
    
    init(seed: UInt64) {
        self.initialState = seed
        self.currentState = seed
    }
    
    mutating func random(in range: ClosedRange<CGFloat>) -> CGFloat {
        currentState = currentState &* 1103515245 &+ 12345
        let normalized = CGFloat(currentState) / CGFloat(UInt64.max)
        return range.lowerBound + (range.upperBound - range.lowerBound) * normalized
    }
    
    mutating func random(in range: ClosedRange<Double>) -> Double {
        currentState = currentState &* 1103515245 &+ 12345
        let normalized = Double(currentState) / Double(UInt64.max)
        return range.lowerBound + (range.upperBound - range.lowerBound) * normalized
    }
}

#Preview {
    RainDropletsAnimation()
        .frame(width: 400, height: 800)
        .background(Color.ivoryLight)
}

