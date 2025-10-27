//
//  NotificationTimePage.swift
//  Peony
//
//  Extracted from OnboardingView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Onboarding page for selecting notification time preferences
struct NotificationTimePage: View {
    @Binding var wateringReminderHour: Int
    @Binding var wateringReminderMinute: Int
    
    @State private var emojiScale: CGFloat = 0.5
    @State private var emojiOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Animated clock emoji
            Text("⏰")
                .font(.system(size: 72))
                .scaleEffect(emojiScale)
                .opacity(emojiOpacity)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: emojiScale)
                .animation(.easeIn(duration: 0.5), value: emojiOpacity)
            
            // Content card
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("What time works for you?")
                        .font(.serifHeadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    Text("We'll remind you to water your seeds")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.dimGray)
                        .padding(.horizontal, 8)
                }
                
                Divider()
                    .padding(.horizontal, 16)
                
                // Time picker
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
                .frame(height: 216)
                .padding(.horizontal, 16)
                
                Text("You can always change this later")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .frame(maxWidth: 320)
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
    NotificationTimePage(
        wateringReminderHour: .constant(9),
        wateringReminderMinute: .constant(0)
    )
    .background(Color.ivoryLight)
}

