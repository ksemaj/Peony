//
//  OnboardingPageView.swift
//  Peony
//
//  Extracted from OnboardingView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Single page in the onboarding flow with animated emoji and content
struct OnboardingPageView: View {
    let emoji: String
    let title: String
    let description: String
    let pageIndex: Int
    
    @State private var emojiScale: CGFloat = 0.5
    @State private var emojiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Animated emoji
            Text(emoji)
                .font(.system(size: 72))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Content card
            VStack(spacing: 12) {
                Text(title)
                    .font(.serifHeadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                Text(description)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.dimGray)
                    .lineSpacing(2)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color.cardLight)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 32)
            .opacity(textOpacity)
            .animation(.easeIn(duration: 0.6).delay(0.2), value: textOpacity)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            emojiScale = 1.0
            emojiOpacity = 1.0
            textOpacity = 1.0
        }
        .onDisappear {
            emojiScale = 0.5
            emojiOpacity = 0
            textOpacity = 0
        }
    }
}

#Preview {
    OnboardingPageView(
        emoji: "🌱",
        title: "Welcome to Peony",
        description: "A mindful space where your thoughts grow and bloom over time",
        pageIndex: 0
    )
    .background(Color.ivoryLight)
}

