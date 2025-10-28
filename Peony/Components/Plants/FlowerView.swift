//
//  FlowerView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Visual representation of a fully bloomed flower (100% growth)
struct FlowerView: View {
    let size: CGFloat
    @State private var petalRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Stem
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(
                    LinearGradient(
                        colors: [Color.stemGreen.opacity(0.9), Color.stemGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.12, height: size * 0.4)
                .offset(y: size * 0.2)
            
            // Petals (open)
            ForEach(0..<6, id: \.self) { index in
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color.flowerPink, Color.flowerPink.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.35, height: size * 0.35)
                    .offset(y: -size * 0.18)
                    .rotationEffect(.degrees(Double(index) * 60 + petalRotation))
            }
            
            // Center
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.flowerCenter, Color.flowerCenter.opacity(0.9)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.12
                    )
                )
                .frame(width: size * 0.25, height: size * 0.25)
                .overlay(
                    Circle()
                        .fill(Color.flowerCenter.opacity(0.5))
                        .frame(width: size * 0.12, height: size * 0.12)
                        .offset(x: -size * 0.04, y: -size * 0.04)
                )
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.2), radius: size * 0.1, x: 0, y: size * 0.05)
        .drawingGroup() // Performance: Render as single layer
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                petalRotation = 360
            }
        }
    }
}

#Preview {
    FlowerView(size: 80)
        .padding()
        .background(Color.ivoryLight)
}




