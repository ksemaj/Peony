//
//  AIFeaturesPage.swift
//  Peony
//
//  Extracted from OnboardingView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Onboarding page for configuring AI features
struct AIFeaturesPage: View {
    @Binding var moodDetectionEnabled: Bool
    @Binding var promptFrequency: String
    @Binding var themeAnalysisEnabled: Bool
    @Binding var seedSuggestionsEnabled: Bool
    
    @State private var emojiScale: CGFloat = 0.5
    @State private var emojiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Emoji header with animation
            Text("🤖")
                .font(.system(size: 72))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Title and description
            VStack(spacing: 12) {
                Text("AI Features")
                    .font(.serifHeadline)
                    .foregroundColor(.black)

                Text("Enhance your journaling with on-device intelligence")
                    .font(.body)
                    .foregroundColor(.softGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .opacity(textOpacity)
            
            // Settings card
            VStack(alignment: .leading, spacing: 20) {
                // Mood Detection
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mood Detection")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Automatically detect the mood of your journal entries")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Toggle("", isOn: $moodDetectionEnabled)
                        .labelsHidden()
                }
                
                Divider()
                
                // Writing Prompts
                VStack(alignment: .leading, spacing: 8) {
                    Text("Writing Prompts")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Get daily inspiration to write")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Picker("Frequency", selection: $promptFrequency) {
                        Text("Daily").tag("daily")
                        Text("Weekly").tag("weekly")
                        Text("Off").tag("off")
                    }
                    .pickerStyle(.segmented)
                }
                
                Divider()
                
                // Theme Analysis
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Theme Analysis")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Discover recurring themes in your writing")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Toggle("", isOn: $themeAnalysisEnabled)
                        .labelsHidden()
                }
                
                Divider()
                
                // Seed Suggestions
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Seed Suggestions")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Get suggestions to plant meaningful entries as seeds")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Toggle("", isOn: $seedSuggestionsEnabled)
                        .labelsHidden()
                }
            }
            .padding(20)
            .background(Color.cardLight)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 32)
            .opacity(textOpacity)
            
            // Privacy note
            HStack(spacing: 8) {
                Text("🔒")
                    .font(.caption)
                Text("All AI processing happens on your device. Your data never leaves your iPhone.")
                    .font(.caption)
                    .foregroundColor(.softGray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            .opacity(textOpacity)
            
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
    AIFeaturesPage(
        moodDetectionEnabled: .constant(true),
        promptFrequency: .constant("daily"),
        themeAnalysisEnabled: .constant(true),
        seedSuggestionsEnabled: .constant(true)
    )
    .background(
        LinearGradient(
            colors: [Color.ivoryLight, Color.pastelGreenLight],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}

