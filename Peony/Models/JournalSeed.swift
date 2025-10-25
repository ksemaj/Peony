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
    
    // Growth stages: 0-25% = seed, 26-50% = sprout, 51-75% = stem, 76-99% = bud, 100% = flower
    var growthPercentage: Double {
        let daysPassed = Calendar.current.dateComponents([.day], from: plantedDate, to: Date()).day ?? 0
        
        // Base growth: 1% per day based on configured duration
        let baseGrowth = (Double(daysPassed) / Double(growthDurationDays)) * 100.0
        
        // Watering bonus: each watering adds 1% extra growth
        let wateringBonus = Double(timesWatered) * 1.0
        
        let totalGrowth = baseGrowth + wateringBonus
        return min(totalGrowth, 100.0)
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
        timesWatered += 1
        lastWateredDate = Date()
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

