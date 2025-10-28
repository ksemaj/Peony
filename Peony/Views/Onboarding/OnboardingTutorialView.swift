//
//  OnboardingTutorialView.swift
//  Peony
//
//  Extracted from OnboardingView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Tutorial version of onboarding that can be dismissed from ContentView
struct OnboardingTutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    // Notification preferences (read from AppStorage)
    @AppStorage("wateringReminderHour") private var wateringReminderHour = AppConfig.Notifications.defaultWateringReminderHour
    @AppStorage("wateringReminderMinute") private var wateringReminderMinute = AppConfig.Notifications.defaultWateringReminderMinute
    
    var body: some View {
        ZStack {
            // Pastel background gradient
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
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
                        title: "Seeds: Deep Reflection",
                        description: "Plant journal entries as seeds that take 45 days to bloom. Your entry stays hidden until it fully grows—encouraging patience and delayed gratification. Water daily to speed up growth and build streaks!",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        emoji: "📝",
                        title: "Journal: Daily Capture",
                        description: "Need to jot something down quickly? Use the Journal for instant writing with immediate access. Perfect for daily thoughts, observations, and reflections.",
                        pageIndex: 2
                    )
                    .tag(2)
                    
                    // Notification time selection page
                    NotificationTimePage(
                        wateringReminderHour: $wateringReminderHour,
                        wateringReminderMinute: $wateringReminderMinute
                    )
                    .tag(3)
                    
                    OnboardingPageView(
                        emoji: "🌸",
                        title: "Begin Your Journey",
                        description: "Two journaling modes, one beautiful garden. Start planting seeds and writing in your journal today!",
                        pageIndex: 4
                    )
                    .tag(4)
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
                                .foregroundColor(.warmGold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cardLight)
                                .cornerRadius(12)
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Button(action: {
                        if currentPage < 4 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            isPresented = false
                        }
                    }) {
                        Text(currentPage == 4 ? "Done" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.warmGold, Color.amberGlow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: .warmGold.opacity(0.4), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingTutorialView(isPresented: .constant(true))
}




