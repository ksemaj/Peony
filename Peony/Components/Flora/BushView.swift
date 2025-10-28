//
//  BushView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Decorative bush element for garden
struct BushView: View {
    let size: CGFloat
    let variant: Int
    
    var bushColor: Color {
        variant % 2 == 0 ? Color(red: 0.40, green: 0.60, blue: 0.45) : Color(red: 0.45, green: 0.65, blue: 0.50)
    }
    
    var body: some View {
        ZStack {
            // Base layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [bushColor.opacity(0.9), bushColor.opacity(0.7)],
                        center: .top,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )
                .frame(width: size * 0.9, height: size * 0.7)
                .offset(y: size * 0.05)
            
            // Top highlights
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(bushColor.opacity(0.5))
                    .frame(width: size * 0.3, height: size * 0.25)
                    .offset(
                        x: CGFloat([-0.25, 0, 0.25][i]) * size,
                        y: -size * 0.15
                    )
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

#Preview {
    HStack {
        BushView(size: 60, variant: 0)
        BushView(size: 60, variant: 1)
    }
    .padding()
    .background(Color.ivoryLight)
}


