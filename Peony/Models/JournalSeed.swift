//
//  JournalSeed.swift
//  Peony
//
//  Created for version 1.1
//

import Foundation
import SwiftData
import UIKit

@Model
class JournalSeed {
    var id: UUID
    var content: String
    var plantedDate: Date
    var lastWateredDate: Date
    var title: String
    @Attribute(.externalStorage) var imageData: Data?
    var growthDurationDays: Int
    var timesWatered: Int
    
    // Relationship to watering streak
    var wateringStreak: WateringStreak?
    
    // Growth stages: 0-25% = seed, 26-50% = sprout, 51-75% = stem, 76-99% = bud, 100% = flower
    var growthPercentage: Double {
        let daysPassed = Calendar.current.dateComponents([.day], from: plantedDate, to: Date()).day ?? 0
        
        // Base growth: natural growth based on days passed
        let baseGrowth = (Double(daysPassed) / Double(growthDurationDays)) * 100.0
        
        // Watering bonus with streak multiplier
        let multiplier = wateringStreak?.streakMultiplier ?? 1.0
        let wateringBonus = Double(timesWatered) * AppConfig.wateringBonus * multiplier
        
        let totalGrowth = baseGrowth + wateringBonus
        return min(totalGrowth, AppConfig.maxGrowthPercentage)
    }
    
    var canWaterToday: Bool {
        guard let lastWatered = Calendar.current.dateComponents([.day], from: lastWateredDate, to: Date()).day else {
            return true
        }
        return lastWatered >= 1
    }
    
    var growthStage: GrowthStage {
        switch growthPercentage {
        case 0..<25: return .seed
        case 25..<50: return .sprout
        case 50..<75: return .stem
        case 75..<100: return .bud
        default: return .flower
        }
    }
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    func water() {
        guard canWaterToday else { return }
        
        // Initialize streak if needed
        if wateringStreak == nil {
            wateringStreak = WateringStreak(seedId: id)
        }
        
        // Record the watering in the streak
        wateringStreak?.recordWatering()
        
        // Update seed watering stats
        timesWatered += 1
        lastWateredDate = Date()
    }
    
    // Get current streak count for UI display
    var currentStreakCount: Int {
        wateringStreak?.currentStreak ?? 0
    }
    
    // Get longest streak for UI display
    var longestStreakCount: Int {
        wateringStreak?.longestStreak ?? 0
    }
    
    // Check if we just hit a milestone
    func checkStreakMilestone() -> Int? {
        guard let streak = wateringStreak else { return nil }
        if AppConfig.Streak.milestones.contains(streak.currentStreak) {
            return streak.currentStreak
        }
        return nil
    }
    
    init(content: String, title: String, imageData: Data? = nil, growthDurationDays: Int = 45) {
        self.id = UUID()
        self.content = content
        self.plantedDate = Date()
        self.lastWateredDate = Date().addingTimeInterval(-86400) // Set to yesterday so they can water immediately
        self.title = title
        self.imageData = imageData
        self.growthDurationDays = growthDurationDays
        self.timesWatered = 0
    }
}

