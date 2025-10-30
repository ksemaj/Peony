//
//  WildflowerView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Decorative wildflower cluster for garden
struct WildflowerView: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            // Stem
            Capsule()
                .fill(Color.stemGreen.opacity(0.7))
                .frame(width: size * 0.08, height: size * 0.6)
                .offset(y: size * 0.2)
            
            // Flower head (small)
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color, color.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.1
                        )
                    )
                    .frame(width: size * 0.2, height: size * 0.2)
                    .offset(x: cos(Double(i) * .pi * 2 / 5) * size * 0.12,
                           y: sin(Double(i) * .pi * 2 / 5) * size * 0.12 - size * 0.15)
            }
            
            // Center
            Circle()
                .fill(Color.flowerCenter.opacity(0.9))
                .frame(width: size * 0.15, height: size * 0.15)
                .offset(y: -size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack {
        WildflowerView(size: 50, color: .purple)
        WildflowerView(size: 50, color: .yellow)
        WildflowerView(size: 50, color: .pink)
    }
    .padding()
    .background(Color.ivoryLight)
}





