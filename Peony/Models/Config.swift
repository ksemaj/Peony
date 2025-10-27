//
//  Config.swift
//  Peony
//
//  Created for version 1.1
//

import Foundation

enum AppConfig {
    // Growth Settings
    static let defaultGrowthDays = 45
    static let minGrowthDays = 30
    static let maxGrowthDays = 365
    static let wateringBonus = 1.0 // base percentage
    static let maxGrowthPercentage = 100.0
    
    // Garden Layout
    static let seedsPerBed = 9
    
    // Watering Streak Settings
    enum Streak {
        static let tierOneMultiplier = 1.0   // Days 1-6: +1.0%
        static let tierTwoMultiplier = 1.5   // Days 7-29: +1.5%
        static let tierThreeMultiplier = 2.0 // Day 30+: +2.0%
        
        static let tierTwoThreshold = 7
        static let tierThreeThreshold = 30
        
        // Streak milestones for celebrations
        static let milestones = [7, 14, 30, 60, 90, 180, 365]
    }
    
    // Notification Settings
    enum Notifications {
        static let defaultWateringReminderHour = 9
        static let defaultWateringReminderMinute = 0
        static let defaultWeeklyCheckinWeekday = 1 // Sunday
        static let defaultWeeklyCheckinHour = 10
        static let defaultWeeklyCheckinMinute = 0
    }
    
    // Journal Settings (v2.0, renamed from QuickNotes in v2.6)
    enum Journal {
        static let minCharacters = 1
        static let maxCharacters = 10000 // ~2000 words
        static let enableMoodDetection = false // Enable in v2.5 with AI
    }
    
    // App Info
    static let appVersion = "2.0.0"
    // TODO: Replace with actual URLs before App Store submission
    static let privacyPolicyURL = "https://example.com/privacy"  // FIXME: Replace before release
    static let supportURL = "https://example.com/support"  // FIXME: Replace before release
    
    // Premium Features (v4.0 - Future Implementation)
    enum Premium {
        static let freeWateringsPerDay = 1
        static let premiumWateringsPerDay = 3
        static let premiumStreakBoost = 1.25 // 25% extra streak bonus
    }
    
    // AI Settings (v2.5 - On-Device Implementation)
    enum AI {
        static var provider: AIProvider = .appleCoreML  // Default to on-device
        
        // On-Device AI (Free)
        static let moodDetectionEnabledKey = "aiMoodDetectionEnabled"
        static let promptFrequencyKey = "aiPromptFrequency"
        static let themeAnalysisEnabledKey = "aiThemeAnalysisEnabled"
        static let seedSuggestionsEnabledKey = "aiSeedSuggestionsEnabled"
        
        // Cloud AI (Premium - Future)
        // ⚠️ SECURITY WARNING: Never store API keys in UserDefaults or code!
        // Use Keychain for sensitive data when implementing cloud features.
        static var openAIKey: String? = nil  // TODO: Move to Keychain (v2.6)
        static var claudeKey: String? = nil  // TODO: Move to Keychain (v2.6)
        
        // Defaults
        static func registerDefaults() {
            let defaults: [String: Any] = [
                moodDetectionEnabledKey: true,  // Enable by default
                promptFrequencyKey: "daily",    // Show prompts daily
                themeAnalysisEnabledKey: true,
                seedSuggestionsEnabledKey: true // Enable by default
            ]
            UserDefaults.standard.register(defaults: defaults)
        }
        
        // Prompt frequency options
        enum PromptFrequency: String, CaseIterable {
            case daily = "daily"
            case weekly = "weekly"
            case off = "off"
            
            var displayName: String {
                switch self {
                case .daily: return "Daily"
                case .weekly: return "Weekly"
                case .off: return "Off"
                }
            }
        }
    }
}

enum AIProvider: String, CaseIterable {
    case none = "None"
    case openAI = "OpenAI"
    case claude = "Claude"
    case appleCoreML = "On-Device"
}

