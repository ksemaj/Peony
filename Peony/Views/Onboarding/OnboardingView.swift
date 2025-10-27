//
//  OnboardingView.swift
//  Peony
//
//  Created for version 1.0
//  Updated for v1.3.1 - Added notification setup
//  Refactored - Modular Architecture Cleanup (extracted sub-views)
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @StateObject private var notificationManager = NotificationManager.shared
    
    // AI preferences (v2.5)
    @AppStorage("aiMoodDetectionEnabled") private var moodDetectionEnabled = true
    @AppStorage("aiPromptFrequency") private var promptFrequency = "daily"
    @AppStorage("aiThemeAnalysisEnabled") private var themeAnalysisEnabled = true
    @AppStorage("aiSeedSuggestionsEnabled") private var seedSuggestionsEnabled = true
    
    // Notification preferences
    @AppStorage("wateringRemindersEnabled") private var wateringRemindersEnabled = true
    @AppStorage("wateringReminderHour") private var wateringReminderHour = AppConfig.Notifications.defaultWateringReminderHour
    @AppStorage("wateringReminderMinute") private var wateringReminderMinute = AppConfig.Notifications.defaultWateringReminderMinute
    @AppStorage("weeklyCheckinEnabled") private var weeklyCheckinEnabled = true
    
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
                    
                    Button {
                        print("🎯 Button tapped - currentPage: \(currentPage)")
                        if currentPage < 4 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            print("🎯 Get Started button pressed! About to set hasSeenOnboarding")
                            print("🎯 Current hasSeenOnboarding value: \(hasSeenOnboarding)")
                            
                            // Set WITHOUT animation to avoid blocking
                            hasSeenOnboarding = true
                            
                            print("🎯 hasSeenOnboarding NOW: \(hasSeenOnboarding)")
                            
                            // Schedule notifications in background
                            Task {
                                let authorized = await notificationManager.requestAuthorization()
                                if authorized {
                                    notificationManager.scheduleDailyWateringReminder(enabled: wateringRemindersEnabled)
                                    notificationManager.scheduleWeeklyCheckin(enabled: weeklyCheckinEnabled)
                                }
                            }
                        }
                    } label: {
                        Text(currentPage == 4 ? "Get Started" : "Next")
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
    OnboardingView(hasSeenOnboarding: .constant(false))
}

