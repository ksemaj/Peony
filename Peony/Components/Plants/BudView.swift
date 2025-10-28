//
//  BudView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Visual representation of a bud forming (75-99% growth)
struct BudView: View {
    let size: CGFloat
    
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
                .frame(width: size * 0.12, height: size * 0.5)
                .offset(y: size * 0.15)
            
            // Bud petals (closed)
            ForEach(0..<5, id: \.self) { index in
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color.budPink.opacity(0.95), Color.budPink.opacity(0.75)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size * 0.25, height: size * 0.4)
                    .rotationEffect(.degrees(Double(index) * 72))
                    .offset(y: -size * 0.15)
            }
            
            // Highlight
            Circle()
                .fill(Color.budPink.opacity(0.4))
                .frame(width: size * 0.2, height: size * 0.2)
                .offset(x: -size * 0.05, y: -size * 0.2)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.15), radius: size * 0.08, x: 0, y: size * 0.04)
    }
}

#Preview {
    BudView(size: 80)
        .padding()
        .background(Color.ivoryLight)
}




