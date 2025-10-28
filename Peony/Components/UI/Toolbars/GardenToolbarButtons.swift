//
//  GardenToolbarButtons.swift
//  Peony
//
//  Extracted from ContentView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Garden view leading toolbar buttons (help/tutorial)
struct GardenToolbarButtons: View {
    @Binding var showingOnboarding: Bool
    
    var body: some View {
        // Help button
        Button {
            showingOnboarding = true
        } label: {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.green)
        }
        .accessibilityLabel("Help and tutorials")
        .accessibilityHint("Tap to view garden tutorials and tips")
    }
}

/// Debug time button - cycles through times of day for testing
struct DebugTimeButton: View {
    @Bindable var timeManager = TimeManager.shared
    @State private var showingDebugAlert = false

    var body: some View {
        Button {
            if !timeManager.isDebugMode {
                // First tap: enable debug mode
                timeManager.isDebugMode = true
                timeManager.debugTimeOfDay = .afternoon
                timeManager.updateDebugTime()
                showingDebugAlert = true
            } else {
                // Subsequent taps: cycle through times
                timeManager.cycleDebugTime()
            }
        } label: {
            Image(systemName: timeManager.isDebugMode ? "clock.fill" : "clock")
                .foregroundColor(timeManager.isDebugMode ? .blue : .gray)
        }
        .accessibilityLabel(timeManager.isDebugMode ? "Debug time mode active. Current time: \(timeManager.debugTimeOfDay.rawValue)" : "Debug time toggle")
        .accessibilityHint("Tap to cycle through different times of day for testing")
        .alert("Debug Mode Enabled", isPresented: $showingDebugAlert) {
            Button("Got it!") { }
            Button("Disable", role: .destructive) {
                timeManager.isDebugMode = false
            }
        } message: {
            Text("Tap the clock to cycle through times of day:\n\n☀️ Sunrise (left) → Day → Afternoon (zenith) → Sunset (right)\n🌙 Evening → Midnight\n\nLong press to disable.")
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 1.0)
                .onEnded { _ in
                    if timeManager.isDebugMode {
                        timeManager.isDebugMode = false
                        showingDebugAlert = false
                    }
                }
        )
    }
}

/// Test notification button (trailing toolbar)
struct NotificationTestButton: View {
    @Environment(\.notificationService) private var notificationService
    @State private var showingNotificationAlert = false
    @State private var notificationAlertMessage = ""
    @State private var isNotificationError = false

    var body: some View {
        Button {
            notificationService.sendTestNotificationWithFeedback { result in
                switch result {
                case .success(let message):
                    notificationAlertMessage = message
                    isNotificationError = false
                case .failure(let error):
                    notificationAlertMessage = error.localizedDescription
                    isNotificationError = notificationAlertMessage.contains("not enabled")
                }
                showingNotificationAlert = true
            }
        } label: {
            Image(systemName: "bell.fill")
                .foregroundColor(.orange)
        }
        .accessibilityLabel("Test notifications")
        .accessibilityHint("Tap to test notification functionality")
        .alert("Notification Test", isPresented: $showingNotificationAlert) {
            if isNotificationError {
                Button("Open Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } else {
                Button("OK") { }
            }
        } message: {
            Text(notificationAlertMessage)
        }
    }
}

#Preview {
    GardenToolbarButtons(
        showingOnboarding: .constant(false)
    )
    .padding()
}

