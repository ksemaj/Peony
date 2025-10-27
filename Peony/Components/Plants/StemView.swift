//
//  StemView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Visual representation of a growing stem (50-74% growth)
struct StemView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Main stem
            RoundedRectangle(cornerRadius: size * 0.05)
                .fill(
                    LinearGradient(
                        colors: [Color.stemGreen.opacity(0.9), Color.stemGreen],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.15, height: size * 0.7)
                .offset(y: size * 0.05)
            
            // Top leaves (3 layers)
            ForEach(0..<3, id: \.self) { index in
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.stemGreen.opacity(0.9 - Double(index) * 0.1),
                                Color.stemGreen.opacity(0.7 - Double(index) * 0.1)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.2
                        )
                    )
                    .frame(width: size * 0.4, height: size * 0.3)
                    .rotationEffect(.degrees(Double(index) * 120 - 60))
                    .offset(y: -size * 0.25)
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: 0, y: size * 0.03)
    }
}

#Preview {
    StemView(size: 80)
        .padding()
        .background(Color.ivoryLight)
}


