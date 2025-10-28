//
//  RockView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Decorative rock element for garden
struct RockView: View {
    let size: CGFloat
    let variant: Int
    
    var body: some View {
        ZStack {
            // Main rock shape
            RoundedRectangle(cornerRadius: size * 0.3)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.60, green: 0.58, blue: 0.55),
                            Color(red: 0.50, green: 0.48, blue: 0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.8, height: size * 0.6)
                .rotationEffect(.degrees(Double(variant) * 15))
            
            // Highlight
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: size * 0.25, height: size * 0.2)
                .offset(x: -size * 0.15, y: -size * 0.1)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.2), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

#Preview {
    HStack {
        RockView(size: 50, variant: 0)
        RockView(size: 50, variant: 1)
        RockView(size: 50, variant: 2)
    }
    .padding()
    .background(Color.ivoryLight)
}


