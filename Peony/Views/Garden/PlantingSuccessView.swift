//
//  PlantingSuccessView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI

/// Success animation shown after planting a seed
struct PlantingSuccessView: View {
    let seed: JournalSeed
    let onDismiss: () -> Void
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var seedScale: CGFloat = 0.5
    @State private var seedRotation: Double = -180
    @State private var showSparkles = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // Dark garden background with blur
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .blur(radius: cardOpacity > 0 ? 20 : 0)
            .opacity(cardOpacity)
            
            // Success card
            VStack(spacing: 24) {
                // Animated seed emoji with sparkles
                ZStack {
                    // Golden sparkles effect
                    if showSparkles {
                        ForEach(0..<12) { index in
                            Image(systemName: "sparkle")
                                .font(.system(size: 16))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.warmGold, Color.amberGlow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .warmGold.opacity(0.5), radius: 4)
                                .offset(
                                    x: cos(Double(index) * .pi / 6) * 50,
                                    y: sin(Double(index) * .pi / 6) * 50
                                )
                                .opacity(showSparkles ? 1 : 0)
                                .scaleEffect(showSparkles ? 1 : 0.1)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(Double(index) * 0.04), value: showSparkles)
                        }
                    }
                    
                    // Main seed
                    SeedView(size: 70)
                        .scaleEffect(seedScale)
                        .rotationEffect(.degrees(seedRotation))
                }
                .padding(.top, 8)
                
                // Success message
                VStack(spacing: 12) {
                    Text("Seed Planted!")
                        .font(.serifHeadline)
                        .foregroundColor(.black)

                    Text(seed.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.softGray)
                        Text("Planted \(seed.plantedDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.softGray)
                    }
                    .padding(.top, 4)
                }
                .opacity(showText ? 1 : 0)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.cardLight)
                    .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
            )
            .frame(maxWidth: 320)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            // Card slides in with ease
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
            
            // Seed animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    seedScale = 1.0
                    seedRotation = 0
                }
            }
            
            // Sparkles burst
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    showSparkles = true
                }
            }
            
            // Text appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showText = true
                }
            }
            
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    cardScale = 0.8
                    cardOpacity = 0
                }
                
                // Call dismiss after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onDismiss()
                }
            }
        }
    }
}

#Preview {
    PlantingSuccessView(seed: JournalSeed(content: "Test", title: "My Seed")) {}
}



