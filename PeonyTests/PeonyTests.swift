//
//  PeonyTests.swift
//  PeonyTests
//
//  Created by James Kinsey on 10/22/25.
//

import Testing
import Foundation
@testable import Peony

// MARK: - Growth Calculation Tests

@Suite("Growth Calculations")
struct GrowthCalculationTests {
    
    @Test("Growth percentage starts at 0 for new seed")
    func testInitialGrowth() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        #expect(seed.growthPercentage == 0.0)
    }
    
    @Test("Growth percentage increases with days passed")
    func testNaturalGrowth() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        // Simulate 10 days passed
        let calendar = Calendar.current
        seed.plantedDate = calendar.date(byAdding: .day, value: -10, to: Date())!
        
        // Expected: (10 days / 45 days) * 100 = 22.22%
        let expectedGrowth = (10.0 / 45.0) * 100.0
        #expect(abs(seed.growthPercentage - expectedGrowth) < 0.01)
    }
    
    @Test("Growth percentage increases with watering")
    func testWateringGrowthBonus() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        // Water the seed 5 times
        seed.timesWatered = 5
        
        // Expected: 0 base growth + (5 waterings * 1.0% * 1.0 multiplier) = 5%
        let expectedGrowth = 5.0 * AppConfig.wateringBonus
        #expect(abs(seed.growthPercentage - expectedGrowth) < 0.01)
    }
    
    @Test("Growth percentage combines days and watering")
    func testCombinedGrowth() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        // Simulate 20 days passed
        let calendar = Calendar.current
        seed.plantedDate = calendar.date(byAdding: .day, value: -20, to: Date())!
        
        // Water 10 times
        seed.timesWatered = 10
        
        // Expected: (20/45 * 100) + (10 * 1.0 * 1.0) = 44.44% + 10% = 54.44%
        let baseGrowth = (20.0 / 45.0) * 100.0
        let wateringBonus = 10.0 * AppConfig.wateringBonus
        let expectedGrowth = baseGrowth + wateringBonus
        
        #expect(abs(seed.growthPercentage - expectedGrowth) < 0.01)
    }
    
    @Test("Growth percentage caps at 100%")
    func testGrowthCap() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        // Simulate way more than needed
        let calendar = Calendar.current
        seed.plantedDate = calendar.date(byAdding: .day, value: -100, to: Date())!
        seed.timesWatered = 100
        
        // Should cap at 100%
        #expect(seed.growthPercentage == 100.0)
    }
    
    @Test("Growth stages are correct")
    func testGrowthStages() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 100
        )
        
        // Test seed stage (0-24%)
        seed.timesWatered = 0
        #expect(seed.growthStage == .seed)
        
        // Test sprout stage (25-49%)
        let calendar = Calendar.current
        seed.plantedDate = calendar.date(byAdding: .day, value: -30, to: Date())!
        #expect(seed.growthStage == .sprout)
        
        // Test stem stage (50-74%)
        seed.plantedDate = calendar.date(byAdding: .day, value: -60, to: Date())!
        #expect(seed.growthStage == .stem)
        
        // Test bud stage (75-99%)
        seed.plantedDate = calendar.date(byAdding: .day, value: -80, to: Date())!
        #expect(seed.growthStage == .bud)
        
        // Test flower stage (100%)
        seed.plantedDate = calendar.date(byAdding: .day, value: -100, to: Date())!
        #expect(seed.growthStage == .flower)
    }
}

// MARK: - Watering Tests

@Suite("Watering Mechanics")
struct WateringTests {
    
    @Test("New seed can be watered immediately")
    func testNewSeedCanWater() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        // Seeds are initialized with lastWateredDate set to yesterday
        #expect(seed.canWaterToday == true)
    }
    
    @Test("Cannot water twice in same day")
    func testCannotWaterTwice() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        // Water the seed
        seed.lastWateredDate = Date()
        
        // Should not be able to water again today
        #expect(seed.canWaterToday == false)
    }
    
    @Test("Can water again next day")
    func testCanWaterNextDay() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        // Water yesterday
        let calendar = Calendar.current
        seed.lastWateredDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        // Should be able to water today
        #expect(seed.canWaterToday == true)
    }
    
    @Test("Watering increments counter")
    func testWateringIncrementsCounter() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        let initialCount = seed.timesWatered
        
        // Make sure we can water (set to yesterday)
        let calendar = Calendar.current
        seed.lastWateredDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        seed.water()
        
        #expect(seed.timesWatered == initialCount + 1)
    }
}

// MARK: - Streak Tests

@Suite("Watering Streaks")
struct StreakTests {
    
    @Test("New streak starts at 0")
    func testNewStreakStartsAtZero() {
        let streak = WateringStreak(seedId: UUID())
        #expect(streak.currentStreak == 0)
        #expect(streak.longestStreak == 0)
    }
    
    @Test("Streak multiplier tier 1 (days 1-6)")
    func testStreakTier1Multiplier() {
        let streak = WateringStreak(seedId: UUID())
        streak.currentStreak = 5
        
        #expect(streak.streakMultiplier == AppConfig.Streak.tierOneMultiplier)
    }
    
    @Test("Streak multiplier tier 2 (days 7-29)")
    func testStreakTier2Multiplier() {
        let streak = WateringStreak(seedId: UUID())
        streak.currentStreak = 15
        
        #expect(streak.streakMultiplier == AppConfig.Streak.tierTwoMultiplier)
    }
    
    @Test("Streak multiplier tier 3 (day 30+)")
    func testStreakTier3Multiplier() {
        let streak = WateringStreak(seedId: UUID())
        streak.currentStreak = 45
        
        #expect(streak.streakMultiplier == AppConfig.Streak.tierThreeMultiplier)
    }
    
    @Test("Recording watering increments streak")
    func testRecordingWateringIncrementsStreak() {
        let streak = WateringStreak(seedId: UUID())
        
        // Set up consecutive day scenario
        let calendar = Calendar.current
        streak.lastWateredDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        streak.recordWatering()
        
        #expect(streak.currentStreak == 1)
    }
    
    @Test("Streak breaks after missing a day")
    func testStreakBreaksAfterGap() {
        let streak = WateringStreak(seedId: UUID())
        
        // Build up a streak
        streak.currentStreak = 10
        
        // Water 3 days ago (missed 2 days)
        let calendar = Calendar.current
        streak.lastWateredDate = calendar.date(byAdding: .day, value: -3, to: Date())!
        
        streak.recordWatering()
        
        // Should reset to 1
        #expect(streak.currentStreak == 1)
    }
    
    @Test("Longest streak is tracked")
    func testLongestStreakTracking() {
        let streak = WateringStreak(seedId: UUID())
        
        // Build up a streak
        let calendar = Calendar.current
        for day in 1...10 {
            streak.lastWateredDate = calendar.date(byAdding: .day, value: -(11 - day), to: Date())!
            streak.recordWatering()
        }
        
        let longestStreak = streak.longestStreak
        
        // Break the streak
        streak.lastWateredDate = calendar.date(byAdding: .day, value: -3, to: Date())!
        streak.recordWatering()
        
        // Longest should still be preserved
        #expect(streak.longestStreak == longestStreak)
        #expect(streak.longestStreak >= 10)
    }
    
    @Test("Streak is active within 48 hours")
    func testStreakIsActiveWithin48Hours() {
        let streak = WateringStreak(seedId: UUID())
        
        // Water 30 hours ago
        streak.lastWateredDate = Date().addingTimeInterval(-30 * 3600)
        
        #expect(streak.isActive == true)
    }
    
    @Test("Streak is inactive after 48 hours")
    func testStreakIsInactiveAfter48Hours() {
        let streak = WateringStreak(seedId: UUID())
        
        // Water 50 hours ago
        streak.lastWateredDate = Date().addingTimeInterval(-50 * 3600)
        
        #expect(streak.isActive == false)
    }
    
    @Test("Milestone detection works")
    func testMilestoneDetection() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        let streak = WateringStreak(seedId: seed.id)
        seed.wateringStreak = streak
        
        // Test 7-day milestone
        streak.currentStreak = 7
        #expect(seed.checkStreakMilestone() == 7)
        
        // Test 14-day milestone
        streak.currentStreak = 14
        #expect(seed.checkStreakMilestone() == 14)
        
        // Test 30-day milestone
        streak.currentStreak = 30
        #expect(seed.checkStreakMilestone() == 30)
        
        // Test non-milestone
        streak.currentStreak = 15
        #expect(seed.checkStreakMilestone() == nil)
    }
}

// MARK: - Integration Tests

@Suite("Growth with Streaks")
struct GrowthStreakIntegrationTests {
    
    @Test("Streak multiplier affects growth bonus")
    func testStreakMultiplierAffectsGrowth() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        let streak = WateringStreak(seedId: seed.id)
        seed.wateringStreak = streak
        
        // Build a tier 2 streak (days 7-29)
        streak.currentStreak = 10
        
        // Water 5 times
        seed.timesWatered = 5
        
        // Expected: 5 waterings * 1.0% * 1.5 multiplier = 7.5%
        let expectedBonus = 5.0 * AppConfig.wateringBonus * AppConfig.Streak.tierTwoMultiplier
        
        // Growth should include the multiplied bonus
        #expect(seed.growthPercentage >= expectedBonus)
    }
    
    @Test("Tier 3 streak provides maximum bonus")
    func testTier3StreakMaximumBonus() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        let streak = WateringStreak(seedId: seed.id)
        seed.wateringStreak = streak
        
        // Build a tier 3 streak (30+ days)
        streak.currentStreak = 35
        
        // Water 10 times
        seed.timesWatered = 10
        
        // Expected: 10 waterings * 1.0% * 2.0 multiplier = 20%
        let expectedBonus = 10.0 * AppConfig.wateringBonus * AppConfig.Streak.tierThreeMultiplier
        
        #expect(seed.growthPercentage >= expectedBonus)
    }
}

// MARK: - Missing Tests for Checklist

@Suite("Growth Edge Cases")
struct GrowthEdgeCaseTests {
    
    @Test("Growth percentage with no watering should use time-based progression only")
    func testGrowthPercentage_withNoWatering() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 30
        )
        
        // Simulate 10 days passed
        let calendar = Calendar.current
        seed.plantedDate = calendar.date(byAdding: .day, value: -10, to: Date())!
        
        // No watering, only time-based growth
        seed.timesWatered = 0
        
        // Expected: (10 days / 30 days) * 100 = 33.33%
        let expectedGrowth = (10.0 / 30.0) * 100.0
        #expect(abs(seed.growthPercentage - expectedGrowth) < 0.01)
    }
    
    @Test("Growth percentage with streak should apply multiplier correctly")
    func testGrowthPercentage_withStreak() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test",
            growthDurationDays: 45
        )
        
        let streak = WateringStreak(seedId: seed.id)
        seed.wateringStreak = streak
        
        // Set tier 2 streak (7-29 days)
        streak.currentStreak = 14
        
        // Water 5 times with tier 2 multiplier (1.5)
        seed.timesWatered = 5
        
        // Expected: 5 waterings * 1.0% * 1.5 multiplier = 7.5%
        let expectedBonus = 5.0 * AppConfig.wateringBonus * AppConfig.Streak.tierTwoMultiplier
        #expect(abs(seed.growthPercentage - expectedBonus) < 0.01)
    }
}

@Suite("Streak Edge Cases")
struct StreakEdgeCaseTests {
    
    @Test("Streak multiplier tier calculation across all thresholds")
    func testStreakMultiplier_tierCalculation() {
        let seed = JournalSeed(
            content: "Test seed",
            title: "Test"
        )
        
        let streak = WateringStreak(seedId: seed.id)
        
        // Tier 1: Days 1-6 (multiplier = 1.0)
        streak.currentStreak = 3
        #expect(streak.streakMultiplier == 1.0)
        
        // Tier 2: Days 7-29 (multiplier = 1.5)
        streak.currentStreak = 15
        #expect(streak.streakMultiplier == 1.5)
        
        // Tier 3: Day 30+ (multiplier = 2.0)
        streak.currentStreak = 45
        #expect(streak.streakMultiplier == 2.0)
    }
    
    @Test("Streak breaks after 48 hour window")
    func testStreakBreak_after48Hours() {
        let streak = WateringStreak(seedId: UUID())
        
        // Build up a streak
        streak.currentStreak = 10
        streak.longestStreak = 10
        
        // Water 49 hours ago (just past 48-hour window)
        streak.lastWateredDate = Date().addingTimeInterval(-49 * 3600)
        
        // Streak should be inactive
        #expect(streak.isActive == false)
        
        // Check streak should reset to 0
        streak.checkAndUpdateStreak()
        #expect(streak.currentStreak == 0)
        
        // Longest streak should be preserved
        #expect(streak.longestStreak == 10)
    }
}
