//
//  SeedView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Visual representation of a seed (0-24% growth)
struct SeedView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Seed shell
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color.seedBrown.opacity(0.9), Color.seedBrown],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.4, height: size * 0.6)
                .rotationEffect(.degrees(-15))
                .shadow(color: .black.opacity(0.2), radius: size * 0.05, x: size * 0.02, y: size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    SeedView(size: 80)
        .padding()
        .background(Color.ivoryLight)
}




