//
//  GardenToolbarButtons.swift
//  Peony
//
//  Extracted from ContentView.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Garden view leading toolbar buttons (help and paywall only)
struct GardenToolbarButtons: View {
    @Binding var showingOnboarding: Bool
    @Binding var showingPaywall: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Help button
            Button {
                showingOnboarding = true
            } label: {
                Image(systemName: "questionmark.circle")
                    .foregroundColor(.green)
            }
            
            // Paywall button (for testing premium features)
            Button {
                showingPaywall = true
            } label: {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
            }
        }
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
        showingOnboarding: .constant(false),
        showingPaywall: .constant(false)
    )
    .padding()
}

