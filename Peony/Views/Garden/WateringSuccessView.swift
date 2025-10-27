//
//  WateringSuccessView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI

/// Success animation shown after watering a seed
struct WateringSuccessView: View {
    let seed: JournalSeed
    let streakCount: Int
    let multiplier: Double
    let milestone: Int?
    let onDismiss: () -> Void
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var dropletsVisible = false
    @State private var showText = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background overlay for pastel theme
                Color.white.opacity(0.6)
                    .ignoresSafeArea()
                    .opacity(cardOpacity)
                
                // Water droplet animations
                if dropletsVisible {
                    ForEach(0..<15) { index in
                        Text("💧")
                            .font(.title)
                            .offset(
                                x: CGFloat.random(in: -150...150),
                                y: -geometry.size.height / 2 + CGFloat(index) * 60
                            )
                            .animation(
                                .linear(duration: 2.0).delay(Double(index) * 0.1),
                                value: dropletsVisible
                            )
                    }
                }
            
            // Success card
            VStack(spacing: 20) {
                // Water droplet icon
                Text("💧")
                    .font(.system(size: 44))
                
                // Success message
                VStack(spacing: 8) {
                    Text("Watered!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("+\(String(format: "%.1f", multiplier))% growth")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    // Streak display
                    if streakCount > 0 {
                        HStack(spacing: 4) {
                            Text("🔥")
                            Text("\(streakCount) day streak!")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 4)
                    }
                    
                    // Milestone celebration
                    if let milestone = milestone {
                        Text("🎉 \(milestone)-Day Milestone! 🎉")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .padding(.top, 8)
                    }
                }
                .opacity(showText ? 1 : 0)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .frame(maxWidth: 320)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            // Card animation
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
            
            // Droplets
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    dropletsVisible = true
                }
            }
            
            // Text appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showText = true
                }
            }
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Auto-dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    cardScale = 0.8
                    cardOpacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            }
        }
        }
    }
}

#Preview {
    WateringSuccessView(
        seed: JournalSeed(content: "Test", title: "My Seed"),
        streakCount: 7,
        multiplier: 1.5,
        milestone: 7
    ) {
        print("Dismissed")
    }
}

