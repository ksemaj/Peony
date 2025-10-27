//
//  GrassBladeView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Animated grass blade for garden foreground
struct GrassBladeView: View {
    let size: CGFloat
    let rotation: Double
    @State private var swayOffset: Double = 0

    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.35, green: 0.58, blue: 0.38).opacity(0.4),
                        Color(red: 0.25, green: 0.48, blue: 0.28).opacity(0.25)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: size * 0.15, height: size)
            .rotationEffect(.degrees(rotation + swayOffset))
            .onAppear {
                // Enhanced wind sway animation - more visible movement
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2.0...3.5))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...1.5))
                ) {
                    swayOffset = Double.random(in: -12...12) // Increased range for more movement
                }
            }
    }
}

#Preview {
    HStack(spacing: 10) {
        ForEach(0..<5, id: \.self) { _ in
            GrassBladeView(size: 40, rotation: Double.random(in: -15...15))
        }
    }
    .padding()
    .background(Color.ivoryLight)
}


