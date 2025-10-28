//
//  GardenPathView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Decorative garden path with stone texture
struct GardenPathView: View {
    @State private var scaleX: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Base path
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.85, green: 0.82, blue: 0.75))
                .frame(height: 40)
                .padding(.horizontal, 40)
            
            // Stone texture overlay
            HStack(spacing: 8) {
                ForEach(0..<12, id: \.self) { i in
                    Circle()
                        .fill(Color(red: 0.8, green: 0.77, blue: 0.7).opacity(0.4))
                        .frame(width: CGFloat.random(in: 8...14), height: CGFloat.random(in: 8...14))
                        .offset(y: CGFloat.random(in: -8...8))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(x: scaleX, y: 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.4)) {
                scaleX = 1.0
            }
        }
    }
}

#Preview {
    GardenPathView()
        .padding()
        .background(Color.ivoryLight)
}


