//
//  NotificationManager.swift
//  Peony
//
//  Created for version 1.1
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
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }
    
    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    // MARK: - Schedule Notifications
    
    func scheduleNotifications(for seed: JournalSeed) {
        guard isAuthorized else { return }
        
        // Schedule growth milestone notifications
        scheduleMilestoneNotifications(for: seed)
        
        // Schedule daily watering reminder
        scheduleDailyWateringReminder(for: seed)
        
        // Schedule bloom notification
        scheduleBloomNotification(for: seed)
    }
    
    private func scheduleMilestoneNotifications(for seed: JournalSeed) {
        let milestones: [Double] = [25, 50, 75]
        
        for milestone in milestones {
            // Calculate days needed to reach this milestone
            let daysToMilestone = Int((Double(seed.growthDurationDays) * milestone / 100.0))
            
            if let notificationDate = Calendar.current.date(byAdding: .day, value: daysToMilestone, to: seed.plantedDate) {
                let content = UNMutableNotificationContent()
                content.title = "Growth Milestone! 🌱"
                content.body = "\(seed.title) has reached \(Int(milestone))% growth!"
                content.sound = .default
                
                let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: "\(seed.id.uuidString)-milestone-\(Int(milestone))",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling milestone notification: \(error)")
                    }
                }
            }
        }
    }
    
    private func scheduleDailyWateringReminder(for seed: JournalSeed) {
        // Only schedule if seed hasn't bloomed yet
        guard seed.growthPercentage < 100 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Water! 💧"
        content.body = "Give \(seed.title) some love today to help it grow faster!"
        content.sound = .default
        
        // Schedule for 9 AM daily
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "\(seed.id.uuidString)-watering-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling watering reminder: \(error)")
            }
        }
    }
    
    private func scheduleBloomNotification(for seed: JournalSeed) {
        // Calculate when the seed will bloom (100%)
        let daysToBloom = seed.growthDurationDays
        
        if let bloomDate = Calendar.current.date(byAdding: .day, value: daysToBloom, to: seed.plantedDate) {
            let content = UNMutableNotificationContent()
            content.title = "🌸 Full Bloom! 🌸"
            content.body = "\(seed.title) has fully bloomed! Your journal entry is now revealed."
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: bloomDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "\(seed.id.uuidString)-bloom",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling bloom notification: \(error)")
                }
            }
        }
    }
    
    // MARK: - Cancel Notifications
    
    func cancelNotifications(for seed: JournalSeed) {
        let identifiers = [
            "\(seed.id.uuidString)-milestone-25",
            "\(seed.id.uuidString)-milestone-50",
            "\(seed.id.uuidString)-milestone-75",
            "\(seed.id.uuidString)-watering-reminder",
            "\(seed.id.uuidString)-bloom"
        ]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Weekly Check-in
    
    func scheduleWeeklyCheckin() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Visit Your Garden 🌿"
        content.body = "Your seeds are waiting for you! Come check on your growth."
        content.sound = .default
        
        // Schedule for Sunday at 10 AM
        var components = DateComponents()
        components.weekday = 1 // Sunday
        components.hour = 10
        components.minute = 0
        
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
}

