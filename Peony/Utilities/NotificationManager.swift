//
//  NotificationManager.swift
//  Peony
//
//  Created for version 1.3
//

import Foundation
import UserNotifications
import SwiftData
import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        Task {
            await checkAuthorization()
        }
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async -> Bool {
        do {
            print("🔔 NotificationManager: Requesting authorization...")
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            print("🔔 NotificationManager: Authorization granted = \(granted)")
            isAuthorized = granted
            return granted
        } catch {
            print("❌ NotificationManager: Error requesting notification authorization: \(error)")
            return false
        }
    }
    
    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - Bloom Notifications
    
    /// Schedule a notification for when a seed reaches 100% growth
    func scheduleBloomNotification(for seed: JournalSeed) {
        guard isAuthorized else { return }
        
        // Calculate when the seed will bloom naturally (without watering)
        let daysToBloom = seed.growthDurationDays
        guard let bloomDate = Calendar.current.date(byAdding: .day, value: daysToBloom, to: seed.plantedDate) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "🌸 Full Bloom! 🌸"
        content.body = "\(seed.title) has fully bloomed! Your journal entry is now revealed."
        content.sound = .default
        content.badge = 1
        content.userInfo = ["seedId": seed.id.uuidString, "type": "bloom"]
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: bloomDate)
        components.hour = 10 // 10 AM
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: "bloom-\(seed.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling bloom notification: \(error)")
            }
        }
    }
    
    // MARK: - Watering Reminders
    
    /// Schedule daily watering reminder (user configurable)
    func scheduleDailyWateringReminder(enabled: Bool = true) {
        print("🔔 scheduleDailyWateringReminder called - enabled: \(enabled), isAuthorized: \(isAuthorized)")
        
        // Cancel existing
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["daily-watering-reminder"]
        )
        
        guard isAuthorized && enabled else {
            print("🔔 Skipping daily watering reminder - not authorized or not enabled")
            return
        }
        
        let hour = UserDefaults.standard.integer(forKey: "wateringReminderHour")
        let minute = UserDefaults.standard.integer(forKey: "wateringReminderMinute")
        
        print("🔔 UserDefaults - hour: \(hour), minute: \(minute)")
        
        let actualHour = hour > 0 ? hour : AppConfig.Notifications.defaultWateringReminderHour
        let actualMinute = minute > 0 ? minute : AppConfig.Notifications.defaultWateringReminderMinute
        
        print("🔔 Scheduling daily watering reminder for \(actualHour):\(String(format: "%02d", actualMinute))")
        
        let content = UNMutableNotificationContent()
        content.title = "💧 Time to water your garden"
        content.body = "Check on your seeds and help them grow!"
        content.sound = .default
        content.userInfo = ["type": "watering-reminder"]
        
        var components = DateComponents()
        components.hour = actualHour
        components.minute = actualMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "daily-watering-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling watering reminder: \(error)")
            } else {
                print("✅ Daily watering reminder scheduled successfully!")
            }
        }
    }
    
    // MARK: - Weekly Check-in
    
    /// Schedule weekly garden check-in (user configurable)
    func scheduleWeeklyCheckin(enabled: Bool = true) {
        // Cancel existing
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["weekly-checkin"]
        )
        
        guard isAuthorized && enabled else { return }
        
        let weekday = UserDefaults.standard.integer(forKey: "weeklyCheckinWeekday")
        let hour = UserDefaults.standard.integer(forKey: "weeklyCheckinHour")
        let minute = UserDefaults.standard.integer(forKey: "weeklyCheckinMinute")
        
        let actualWeekday = weekday > 0 ? weekday : AppConfig.Notifications.defaultWeeklyCheckinWeekday
        let actualHour = hour > 0 ? hour : AppConfig.Notifications.defaultWeeklyCheckinHour
        let actualMinute = minute > 0 ? minute : AppConfig.Notifications.defaultWeeklyCheckinMinute
        
        let content = UNMutableNotificationContent()
        content.title = "🌿 Visit your garden this week"
        content.body = "Your seeds are growing beautifully!"
        content.sound = .default
        content.userInfo = ["type": "weekly-checkin"]
        
        var components = DateComponents()
        components.weekday = actualWeekday
        components.hour = actualHour
        components.minute = actualMinute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weekly-checkin",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weekly check-in: \(error)")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    
    /// Cancel all notifications for a specific seed
    func cancelNotifications(for seed: JournalSeed) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["bloom-\(seed.id.uuidString)"]
        )
    }
    
    /// Cancel all pending notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Badge Management
    
    /// Update app badge count (number of bloomed seeds)
    func updateBadgeCount(bloomedCount: Int) {
        UNUserNotificationCenter.current().setBadgeCount(bloomedCount) { error in
            if let error = error {
                print("Error updating badge count: \(error)")
            }
        }
    }
    
    /// Clear badge count
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Error clearing badge: \(error)")
            }
        }
    }
    
    // MARK: - Testing
    
    /// Send a test notification immediately
    func sendTestNotification(type: NotificationType) {
        print("🔔 sendTestNotification called - type: \(type), isAuthorized: \(isAuthorized)")
        
        guard isAuthorized else {
            print("❌ Test notification skipped - not authorized")
            return
        }
        
        let content = UNMutableNotificationContent()
        
        switch type {
        case .bloom:
            content.title = "🌸 Test: Bloom Notification"
            content.body = "This is how bloom notifications will look!"
        case .watering:
            content.title = "💧 Test: Watering Reminder"
            content.body = "This is your daily watering reminder!"
        case .weekly:
            content.title = "🌿 Test: Weekly Check-in"
            content.body = "This is your weekly garden check-in!"
        }
        
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(
            identifier: "test-notification-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        print("🔔 Scheduling test notification to fire in 2 seconds...")
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error sending test notification: \(error)")
            } else {
                print("✅ Test notification scheduled successfully!")
            }
        }
    }
    
    enum NotificationType {
        case bloom
        case watering
        case weekly
    }
}

