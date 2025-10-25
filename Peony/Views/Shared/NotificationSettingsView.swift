//
//  NotificationSettingsView.swift
//  Peony
//
//  Created for version 1.3
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var notificationManager = NotificationManager.shared
    
    // Watering reminder settings
    @AppStorage("wateringRemindersEnabled") private var wateringRemindersEnabled = true
    @AppStorage("wateringReminderHour") private var wateringReminderHour = AppConfig.Notifications.defaultWateringReminderHour
    @AppStorage("wateringReminderMinute") private var wateringReminderMinute = AppConfig.Notifications.defaultWateringReminderMinute
    
    // Weekly check-in settings
    @AppStorage("weeklyCheckinEnabled") private var weeklyCheckinEnabled = true
    @AppStorage("weeklyCheckinWeekday") private var weeklyCheckinWeekday = AppConfig.Notifications.defaultWeeklyCheckinWeekday
    @AppStorage("weeklyCheckinHour") private var weeklyCheckinHour = AppConfig.Notifications.defaultWeeklyCheckinHour
    @AppStorage("weeklyCheckinMinute") private var weeklyCheckinMinute = AppConfig.Notifications.defaultWeeklyCheckinMinute
    
    @State private var showingTestAlert = false
    @State private var testNotificationType: NotificationManager.NotificationType = .watering
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    // Authorization status
                    if !notificationManager.isAuthorized {
                        Section {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "bell.slash")
                                        .foregroundColor(.orange)
                                    Text("Notifications Disabled")
                                        .font(.headline)
                                }
                                
                                Text("Enable notifications in Settings to receive reminders and bloom alerts.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    Text("Open Settings")
                                        .fontWeight(.semibold)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Color.white.opacity(0.8))
                    }
                    
                    // Bloom notifications (always on)
                    Section {
                        HStack {
                            Label("Bloom Notifications", systemImage: "flower")
                                .foregroundColor(.black)
                            Spacer()
                            Text("Always On")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } header: {
                        Text("Essential")
                    } footer: {
                        Text("You'll always be notified when your seeds bloom. This cannot be disabled.")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    // Watering reminders
                    Section {
                        Toggle("Daily Watering Reminder", isOn: $wateringRemindersEnabled)
                            .foregroundColor(.black)
                            .onChange(of: wateringRemindersEnabled) { _, newValue in
                                notificationManager.scheduleDailyWateringReminder(enabled: newValue)
                            }
                        
                        if wateringRemindersEnabled {
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
                                        wateringReminderHour = components.hour ?? AppConfig.Notifications.defaultWateringReminderHour
                                        wateringReminderMinute = components.minute ?? AppConfig.Notifications.defaultWateringReminderMinute
                                        notificationManager.scheduleDailyWateringReminder(enabled: wateringRemindersEnabled)
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .foregroundColor(.black)
                            
                            Button {
                                testNotificationType = .watering
                                notificationManager.sendTestNotification(type: .watering)
                                showingTestAlert = true
                            } label: {
                                Label("Send Test Notification", systemImage: "paperplane")
                            }
                        }
                    } header: {
                        Text("Watering Reminders")
                    } footer: {
                        Text("Get a daily reminder to water your seeds at your chosen time.")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                    
                    // Weekly check-in
                    Section {
                        Toggle("Weekly Garden Check-in", isOn: $weeklyCheckinEnabled)
                            .foregroundColor(.black)
                            .onChange(of: weeklyCheckinEnabled) { _, newValue in
                                notificationManager.scheduleWeeklyCheckin(enabled: newValue)
                            }
                        
                        if weeklyCheckinEnabled {
                            Picker("Day of Week", selection: $weeklyCheckinWeekday) {
                                Text("Sunday").tag(1)
                                Text("Monday").tag(2)
                                Text("Tuesday").tag(3)
                                Text("Wednesday").tag(4)
                                Text("Thursday").tag(5)
                                Text("Friday").tag(6)
                                Text("Saturday").tag(7)
                            }
                            .foregroundColor(.black)
                            .onChange(of: weeklyCheckinWeekday) { _, _ in
                                notificationManager.scheduleWeeklyCheckin(enabled: weeklyCheckinEnabled)
                            }
                            
                            DatePicker(
                                "Check-in Time",
                                selection: Binding(
                                    get: {
                                        var components = DateComponents()
                                        components.hour = weeklyCheckinHour
                                        components.minute = weeklyCheckinMinute
                                        return Calendar.current.date(from: components) ?? Date()
                                    },
                                    set: { newDate in
                                        let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                                        weeklyCheckinHour = components.hour ?? AppConfig.Notifications.defaultWeeklyCheckinHour
                                        weeklyCheckinMinute = components.minute ?? AppConfig.Notifications.defaultWeeklyCheckinMinute
                                        notificationManager.scheduleWeeklyCheckin(enabled: weeklyCheckinEnabled)
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .foregroundColor(.black)
                            
                            Button {
                                testNotificationType = .weekly
                                notificationManager.sendTestNotification(type: .weekly)
                                showingTestAlert = true
                            } label: {
                                Label("Send Test Notification", systemImage: "paperplane")
                            }
                        }
                    } header: {
                        Text("Weekly Check-in")
                    } footer: {
                        Text("Get a weekly reminder to visit your garden and check on your progress.")
                    }
                    .listRowBackground(Color.white.opacity(0.8))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
            .alert("Test Notification Sent", isPresented: $showingTestAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Check your notifications in a few seconds!")
            }
        }
    }
}

#Preview {
    NotificationSettingsView()
}

