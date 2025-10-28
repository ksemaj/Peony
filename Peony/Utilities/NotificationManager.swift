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
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            await MainActor.run {
                isAuthorized = granted
            }
            return granted
        } catch {
            return false
        }
    }
    
    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        let authorized = settings.authorizationStatus == .authorized
        await MainActor.run {
            isAuthorized = authorized
        }
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
        // Cancel existing
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["daily-watering-reminder"]
        )
        
        guard isAuthorized && enabled else {
            return
        }
        
        let hour = AppSettings.wateringReminderHour
        let minute = AppSettings.wateringReminderMinute
        
        let actualHour = hour > 0 ? hour : AppConfig.Notifications.defaultWateringReminderHour
        let actualMinute = minute > 0 ? minute : AppConfig.Notifications.defaultWateringReminderMinute
        
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
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - Weekly Check-in
    
    /// Schedule weekly garden check-in (user configurable)
    func scheduleWeeklyCheckin(enabled: Bool = true) {
        // Cancel existing
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["weekly-checkin"]
        )
        
        guard isAuthorized && enabled else { return }
        
        let weekday = AppSettings.weeklyCheckinWeekday
        let hour = AppSettings.weeklyCheckinHour
        let minute = AppSettings.weeklyCheckinMinute
        
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
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
    /// Send test notification with user feedback
    /// - Parameter completion: Returns success message or error
    func sendTestNotificationWithFeedback(completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            // Check authorization
            let authorized = await requestAuthorization()
            
            guard authorized else {
                await MainActor.run {
                    completion(.failure(NSError(
                        domain: "NotificationManager",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Notifications are not enabled.\n\nWould you like to open Settings?"]
                    )))
                }
                return
            }
            
            // Create test notification
            let content = UNMutableNotificationContent()
            content.title = "💧 Peony Watering Reminder"
            content.body = "Time to water your seeds! 🌱"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(
                identifier: "test-notification-\(UUID().uuidString)",
                content: content,
                trigger: trigger
            )
            
            do {
                try await UNUserNotificationCenter.current().add(request)
                
                await MainActor.run {
                    completion(.success("✅ Test notification scheduled!\n\nMinimize the app to see it arrive in 5 seconds."))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func sendTestNotification(type: NotificationType) {
        guard isAuthorized else {
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
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    enum NotificationType {
        case bloom
        case watering
        case weekly
    }
}

