//
//  MushroomView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Decorative mushroom element for garden
struct MushroomView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.95, green: 0.93, blue: 0.88),
                            Color(red: 0.90, green: 0.88, blue: 0.83)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.25, height: size * 0.5)
                .offset(y: size * 0.15)
            
            // Cap
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.85, green: 0.45, blue: 0.45),
                            Color(red: 0.75, green: 0.35, blue: 0.35)
                        ],
                        center: .top,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.7, height: size * 0.45)
                .offset(y: -size * 0.12)
            
            // Spots on cap
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: size * 0.12, height: size * 0.12)
                    .offset(
                        x: CGFloat([-0.15, 0.1, -0.05][i]) * size,
                        y: CGFloat([-0.15, -0.08, -0.20][i]) * size
                    )
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

#Preview {
    MushroomView(size: 60)
        .padding()
        .background(Color.ivoryLight)
}


