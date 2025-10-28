//
//  TreeView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Decorative tree element for garden background
struct TreeView: View {
    let size: CGFloat
    let delay: Double
    @State private var swayOffset: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Tree trunk
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(
                    LinearGradient(
                        colors: [Color.treeTrunkLight, Color.treeTrunkDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.25, height: size * 0.45)
                .offset(y: size * 0.25)
                .shadow(color: .black.opacity(0.15), radius: size * 0.05, x: size * 0.03, y: size * 0.03)
            
            // Foliage - back layer (darkest)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafMid, Color.treeLeafDark],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.40
                    )
                )
                .frame(width: size * 0.75, height: size * 0.75)
                .offset(x: -size * 0.08, y: -size * 0.05)
            
            // Foliage - middle layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafLight, Color.treeLeafMid],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.35
                    )
                )
                .frame(width: size * 0.70, height: size * 0.70)
                .offset(x: size * 0.08, y: -size * 0.08)
            
            // Foliage - front layer (lightest)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.treeLeafLight, Color.treeLeafMid.opacity(0.9)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: size * 0.30
                    )
                )
                .frame(width: size * 0.60, height: size * 0.60)
                .offset(y: -size * 0.12)
                .shadow(color: .black.opacity(0.1), radius: size * 0.08, x: 0, y: size * 0.05)
        }
        .frame(width: size, height: size)
        .rotationEffect(.degrees(swayOffset))
        .scaleEffect(scale)
        .drawingGroup() // Performance: Render as single layer
        .onAppear {
            // Enhanced sway animation - more noticeable
            withAnimation(
                .easeInOut(duration: 6.0)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                swayOffset = 3.0 // Increased from 1.5
            }
        }
    }
}

#Preview {
    TreeView(size: 100, delay: 0)
        .padding()
        .background(Color.ivoryLight)
}




