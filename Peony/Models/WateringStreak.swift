//
//  WateringStreak.swift
//  Peony
//
//  Created for version 1.3
//

import Foundation
import SwiftData

@Model
class WateringStreak {
    var seedId: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastWateredDate: Date
    var wateringDates: [Date] // Track all watering dates for calendar view
    
    // Streak multiplier based on consecutive days
    var streakMultiplier: Double {
        switch currentStreak {
        case 0...6:
            return 1.0  // Days 1-6: +1.0% per watering
        case 7...29:
            return 1.5  // Days 7-29: +1.5% per watering
        default:
            return 2.0  // Day 30+: +2.0% per watering
        }
    }
    
    // Check if streak is still active (watered within last 48 hours to allow some grace)
    var isActive: Bool {
        let hoursSinceLastWater = Date().timeIntervalSince(lastWateredDate) / 3600
        return hoursSinceLastWater < 48
    }
    
    // Get watering history for last 7 days
    var last7DaysHistory: [Bool] {
        var history: [Bool] = []
        let calendar = Calendar.current
        
        for daysAgo in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) {
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let wateredOnDay = wateringDates.contains { waterDate in
                    waterDate >= dayStart && waterDate < dayEnd
                }
                history.append(wateredOnDay)
            }
        }
        
        return history
    }
    
    init(seedId: UUID) {
        self.seedId = seedId
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastWateredDate = Date().addingTimeInterval(-86400 * 2) // 2 days ago (inactive)
        self.wateringDates = []
    }
    
    // Record a watering and update streak
    func recordWatering() {
        let now = Date()
        let calendar = Calendar.current
        
        // Check if this is a consecutive day
        if let daysSinceLastWater = calendar.dateComponents([.day], from: lastWateredDate, to: now).day {
            if daysSinceLastWater == 1 {
                // Consecutive day - increment streak
                currentStreak += 1
            } else if daysSinceLastWater > 1 {
                // Streak broken - restart
                currentStreak = 1
            }
            // If daysSinceLastWater == 0, already watered today (shouldn't happen with canWaterToday check)
        }
        
        // Update longest streak if current exceeds it
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        
        // Record the watering
        lastWateredDate = now
        wateringDates.append(now)
        
        // Keep only last 30 days of watering dates for performance
        if wateringDates.count > 30 {
            wateringDates = Array(wateringDates.suffix(30))
        }
    }
    
    // Check for streak break and update if needed
    func checkAndUpdateStreak() {
        if !isActive && currentStreak > 0 {
            currentStreak = 0
        }
    }
}

