//
//  DirtMoundView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Dirt mound visual effect for planted seeds
struct DirtMoundView: View {
    let size: CGFloat
    
    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [Color.dirtLight.opacity(0.6), Color.dirtDark.opacity(0.5)],
                    center: .top,
                    startRadius: 0,
                    endRadius: size * 0.5
                )
            )
            .frame(width: size, height: size * 0.6)
            .blur(radius: 2)
            .overlay(
                Ellipse()
                    .fill(Color.dirtDark.opacity(0.2))
                    .frame(width: size * 0.7, height: size * 0.4)
                    .offset(y: size * 0.1)
            )
    }
}

#Preview {
    DirtMoundView(size: 60)
        .padding()
        .background(Color.ivoryLight)
}


