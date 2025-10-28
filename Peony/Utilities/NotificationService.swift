//
//  NotificationService.swift
//  Peony
//
//  Protocol abstraction for notification management
//  Enables dependency injection and testing
//

import Foundation
import SwiftUI

/// Protocol defining notification service behavior
/// Abstracts NotificationManager for dependency injection
protocol NotificationService {
    /// Whether user has authorized notifications
    var isAuthorized: Bool { get }
    
    /// Request notification authorization from user
    func requestAuthorization() async -> Bool
    
    /// Check current authorization status
    func checkAuthorization() async
    
    /// Schedule a notification when a seed reaches 100% growth
    func scheduleBloomNotification(for seed: JournalSeed)
    
    /// Schedule daily watering reminder
    func scheduleDailyWateringReminder(enabled: Bool)
    
    /// Schedule weekly garden check-in
    func scheduleWeeklyCheckin(enabled: Bool)
    
    /// Cancel all notifications for a specific seed
    func cancelNotifications(for seed: JournalSeed)
    
    /// Send test notification with user feedback
    func sendTestNotificationWithFeedback(completion: @escaping (Result<String, Error>) -> Void)
}

/// Live implementation of NotificationService using NotificationManager
class LiveNotificationService: NotificationService {
    private let manager = NotificationManager.shared
    
    var isAuthorized: Bool {
        manager.isAuthorized
    }
    
    func requestAuthorization() async -> Bool {
        await manager.requestAuthorization()
    }
    
    func checkAuthorization() async {
        await manager.checkAuthorization()
    }
    
    func scheduleBloomNotification(for seed: JournalSeed) {
        manager.scheduleBloomNotification(for: seed)
    }
    
    func scheduleDailyWateringReminder(enabled: Bool) {
        manager.scheduleDailyWateringReminder(enabled: enabled)
    }
    
    func scheduleWeeklyCheckin(enabled: Bool) {
        manager.scheduleWeeklyCheckin(enabled: enabled)
    }
    
    func cancelNotifications(for seed: JournalSeed) {
        manager.cancelNotifications(for: seed)
    }
    
    func sendTestNotificationWithFeedback(completion: @escaping (Result<String, Error>) -> Void) {
        manager.sendTestNotificationWithFeedback(completion: completion)
    }
}

/// Mock implementation for testing and previews
class MockNotificationService: NotificationService {
    var isAuthorized = true
    var scheduledSeeds: [UUID] = []
    var wateringReminderScheduled = false
    var weeklyCheckinScheduled = false
    
    func requestAuthorization() async -> Bool {
        isAuthorized = true
        return true
    }
    
    func checkAuthorization() async {
        // Mock always authorized
    }
    
    func scheduleBloomNotification(for seed: JournalSeed) {
        scheduledSeeds.append(seed.id)
    }
    
    func scheduleDailyWateringReminder(enabled: Bool) {
        wateringReminderScheduled = enabled
    }
    
    func scheduleWeeklyCheckin(enabled: Bool) {
        weeklyCheckinScheduled = enabled
    }
    
    func cancelNotifications(for seed: JournalSeed) {
        scheduledSeeds.removeAll { $0 == seed.id }
    }
    
    func sendTestNotificationWithFeedback(completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("🧪 Mock notification sent!"))
    }
}

// MARK: - SwiftUI Environment

private struct NotificationServiceKey: EnvironmentKey {
    static let defaultValue: NotificationService = LiveNotificationService()
}

extension EnvironmentValues {
    var notificationService: NotificationService {
        get { self[NotificationServiceKey.self] }
        set { self[NotificationServiceKey.self] = newValue }
    }
}

