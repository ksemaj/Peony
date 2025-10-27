//
//  OnboardingView.swift
//  Peony
//
//  Created for version 1.0
//  Updated for v1.3.1 - Added notification setup
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
                    
                    // AI Features page (v2.5)
                    AIFeaturesPage(
                        moodDetectionEnabled: $moodDetectionEnabled,
                        promptFrequency: $promptFrequency,
                        themeAnalysisEnabled: $themeAnalysisEnabled,
                        seedSuggestionsEnabled: $seedSuggestionsEnabled
                    )
                    .tag(3)
                    
                    // Notification time selection page
                    SimpleNotificationTimePage(
                        wateringReminderHour: $wateringReminderHour,
                        wateringReminderMinute: $wateringReminderMinute
                    )
                    .tag(4)
                    
                    OnboardingPageView(
                        emoji: "🌸",
                        title: "Begin Your Journey",
                        description: "Two journaling modes, one beautiful garden. Start planting seeds and writing in your journal today!",
                        pageIndex: 5
                    )
                    .tag(5)
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
                        if currentPage < 5 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            // Schedule notifications with user preferences
                            Task {
                                print("🔔 Requesting notification authorization...")
                                let authorized = await notificationManager.requestAuthorization()
                                print("🔔 Authorization result: \(authorized)")
                                
                                if authorized {
                                    print("🔔 Scheduling daily watering reminder (enabled: \(wateringRemindersEnabled))")
                                    notificationManager.scheduleDailyWateringReminder(enabled: wateringRemindersEnabled)
                                    
                                    print("🔔 Scheduling weekly check-in (enabled: \(weeklyCheckinEnabled))")
                                    notificationManager.scheduleWeeklyCheckin(enabled: weeklyCheckinEnabled)
                                }
                                
                                // Wait a bit to ensure notifications are scheduled
                                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                                
                                await MainActor.run {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        hasSeenOnboarding = true
                                    }
                                }
                            }
                        }
                    }) {
                        Text(currentPage == 5 ? "Get Started" : "Next")
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
    
    // Notification preferences (read from AppStorage)
    @AppStorage("wateringReminderHour") private var wateringReminderHour = AppConfig.Notifications.defaultWateringReminderHour
    @AppStorage("wateringReminderMinute") private var wateringReminderMinute = AppConfig.Notifications.defaultWateringReminderMinute
    
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
                    SimpleNotificationTimePage(
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
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.8))
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

// MARK: - Simple Notification Time Page (Page 3)
struct SimpleNotificationTimePage: View {
    @Binding var wateringReminderHour: Int
    @Binding var wateringReminderMinute: Int
    
    @State private var emojiScale: CGFloat = 0.5
    @State private var emojiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Animated clock emoji
            Text("⏰")
                .font(.system(size: 100))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .padding(.top, 20)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Content card
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("What time works for you?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Text("We'll remind you to water your seeds")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                Divider()
                    .padding(.horizontal)
                
                // Large time picker
                DatePicker(
                    "Reminder Time",
                    selection: Binding(
                        get: {
                            var components = DateComponents()
                            components.hour = wateringReminderHour
                            components.minute = wateringReminderMinute
                            return Calendar.current.date(from: components) ?? Date()
                        },
                        set: { newDate in
                            let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                            wateringReminderHour = components.hour ?? 9
                            wateringReminderMinute = components.minute ?? 0
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                Text("You can always change this later")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.9))
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

// MARK: - AI Features Page (Page 3)

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
                .font(.system(size: 80))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Title and description
            VStack(spacing: 12) {
                Text("AI Features")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Enhance your journaling with on-device intelligence")
                    .font(.body)
                    .foregroundColor(.gray)
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
            .background(Color.white.opacity(0.9))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 32)
            .opacity(textOpacity)
            
            // Privacy note
            HStack(spacing: 8) {
                Text("🔒")
                    .font(.caption)
                Text("All AI processing happens on your device. Your data never leaves your iPhone.")
                    .font(.caption)
                    .foregroundColor(.gray)
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
    OnboardingView(hasSeenOnboarding: .constant(false))
}

