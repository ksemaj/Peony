//
//  SproutView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Visual representation of a sprout (25-49% growth)
struct SproutView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.sproutGreen, Color.sproutGreen.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.12, height: size * 0.5)
                .offset(y: size * 0.1)
            
            // Left leaf
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.sproutGreen, Color.sproutGreen.opacity(0.7)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.35, height: size * 0.25)
                .rotationEffect(.degrees(-45))
                .offset(x: -size * 0.15, y: -size * 0.05)
            
            // Right leaf
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.sproutGreen.opacity(0.95), Color.sproutGreen.opacity(0.75)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.35, height: size * 0.25)
                .rotationEffect(.degrees(45))
                .offset(x: size * 0.15, y: -size * 0.1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

#Preview {
    SproutView(size: 80)
        .padding()
        .background(Color.ivoryLight)
}




