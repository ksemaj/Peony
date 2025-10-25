//
//  OnboardingView.swift
//  Peony
//
//  Created for version 1.0
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Garden background gradient
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 1.0, blue: 0.94),
                    Color(red: 0.88, green: 0.95, blue: 0.88),
                    Color(red: 0.98, green: 0.98, blue: 0.90)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Page content
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        emoji: "🌱",
                        title: "Welcome to Peony",
                        description: "A mindful space where your thoughts grow and bloom over time",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        emoji: "🪴",
                        title: "Plant Seeds, Watch Them Grow",
                        description: "Each journal entry is a seed that grows into a beautiful flower over 365 days",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        emoji: "🌸",
                        title: "Begin Your Journey",
                        description: "Start planting seeds and cultivate your personal garden of growth",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                hasSeenOnboarding = true
                            }
                        }
                    }) {
                        Text(currentPage == 2 ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let emoji: String
    let title: String
    let description: String
    let pageIndex: Int
    
    @State private var emojiScale: CGFloat = 0.5
    @State private var emojiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Animated emoji
            Text(emoji)
                .font(.system(size: 120))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Content card
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .padding(.horizontal, 8)
            }
            .padding(32)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.8))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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

// Tutorial version that can be dismissed from ContentView
struct OnboardingTutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Garden background gradient
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 1.0, blue: 0.94),
                    Color(red: 0.88, green: 0.95, blue: 0.88),
                    Color(red: 0.98, green: 0.98, blue: 0.90)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            .padding()
                    }
                }
                
                Spacer()
                
                // Page content
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        emoji: "🌱",
                        title: "Welcome to Peony",
                        description: "A mindful space where your thoughts grow and bloom over time",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        emoji: "🪴",
                        title: "Plant Seeds, Watch Them Grow",
                        description: "Each journal entry is a seed that grows into a beautiful flower over 365 days",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        emoji: "🌸",
                        title: "Begin Your Journey",
                        description: "Start planting seeds and cultivate your personal garden of growth",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            isPresented = false
                        }
                    }) {
                        Text(currentPage == 2 ? "Done" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}

