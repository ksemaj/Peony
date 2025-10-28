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
    static let appVersion = "2.6.0"
    
    // Privacy & Support URLs
    // TODO: Create actual privacy policy and support pages before App Store submission
    // Uncomment and update these when ready:
    // static let privacyPolicyURL = "https://yourdomain.com/privacy"
    // static let supportURL = "https://yourdomain.com/support"
    
    // AI Settings (v2.5 - On-Device Implementation)
    // Note: AI settings now managed by AppSettings utility
    enum AI {
        static var provider: AIProvider = .appleCoreML  // Default to on-device
        
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

// MARK: - Environment & Atmosphere Settings

extension AppConfig {
    /// Environment and atmospheric settings for garden visuals
    enum Environment {
        // Hemisphere setting (affects seasonal calculations)
        static let hemisphere: Hemisphere = .northern
        
        // Future feature flags
        static let enableWeatherEffects = false // Weather effects (rain, snow)
        static let enableDynamicClouds = true   // Parallax cloud layers
        static let enableStarField = true       // Night sky stars
        
        /// Time-based configuration
        enum TimeConfig {
            static let updateInterval: TimeInterval = 60 // Update every 1 minute
            static let twilightDurationMinutes = 30      // Duration of dawn/dusk transition
        }
        
        /// Seasonal sky color configurations - 3 day + 3 night stages
        enum SeasonalPalettes {
            // Spring - Fresh pastels with hints of pink and green
            static let springSunrise = [
                (r: 0.85, g: 0.50, b: 0.60),  // Deep pink sunrise
                (r: 0.88, g: 0.60, b: 0.50),  // Rich coral glow
                (r: 0.85, g: 0.65, b: 0.45)   // Warm orange-pink
            ]
            static let springDay = [
                (r: 0.25, g: 0.55, b: 0.85),  // Deep sky blue
                (r: 0.35, g: 0.60, b: 0.87),  // Rich sky blue
                (r: 0.45, g: 0.65, b: 0.88)   // Bright sky blue
            ]
            static let springAfternoon = [
                (r: 0.28, g: 0.58, b: 0.84),  // Deep afternoon blue
                (r: 0.38, g: 0.63, b: 0.86),  // Rich afternoon
                (r: 0.48, g: 0.68, b: 0.87)   // Bright afternoon
            ]
            static let springSunset = [
                (r: 0.88, g: 0.60, b: 0.40),  // Deep peach sunset
                (r: 0.88, g: 0.65, b: 0.35),  // Rich golden orange
                (r: 0.85, g: 0.70, b: 0.40)   // Warm gold glow
            ]
            static let springEvening = [
                (r: 0.10, g: 0.12, b: 0.28),  // Deep twilight purple-blue
                (r: 0.15, g: 0.18, b: 0.35),  // Deep evening blue
                (r: 0.20, g: 0.22, b: 0.40)   // Dark blue evening
            ]
            static let springMidnight = [
                (r: 0.03, g: 0.05, b: 0.15),  // Very deep indigo midnight
                (r: 0.05, g: 0.08, b: 0.20),  // Deep purple-blue
                (r: 0.08, g: 0.10, b: 0.24)   // Dark night blue
            ]
            
            // Summer - Vibrant blues with warm highlights
            static let summerSunrise = [
                (r: 0.88, g: 0.45, b: 0.40),  // Rich coral sunrise
                (r: 0.90, g: 0.55, b: 0.35),  // Deep orange glow
                (r: 0.88, g: 0.65, b: 0.40)   // Rich golden morning
            ]
            static let summerDay = [
                (r: 0.20, g: 0.50, b: 0.88),  // Rich saturated sky blue
                (r: 0.28, g: 0.58, b: 0.88),  // Deep summer blue
                (r: 0.38, g: 0.65, b: 0.88)   // Bright summer sky
            ]
            static let summerAfternoon = [
                (r: 0.25, g: 0.53, b: 0.87),  // Deep afternoon blue
                (r: 0.33, g: 0.60, b: 0.88),  // Rich afternoon
                (r: 0.43, g: 0.67, b: 0.88)   // Bright afternoon
            ]
            static let summerSunset = [
                (r: 0.90, g: 0.50, b: 0.25),  // Rich orange sunset
                (r: 0.88, g: 0.60, b: 0.25),  // Deep gold
                (r: 0.85, g: 0.65, b: 0.30)   // Rich amber glow
            ]
            static let summerEvening = [
                (r: 0.12, g: 0.16, b: 0.30),  // Deep evening blue
                (r: 0.16, g: 0.20, b: 0.38),  // Rich evening
                (r: 0.22, g: 0.24, b: 0.42)   // Dark blue evening
            ]
            static let summerMidnight = [
                (r: 0.03, g: 0.05, b: 0.18),  // Very deep navy midnight
                (r: 0.06, g: 0.08, b: 0.22),  // Deep night blue
                (r: 0.10, g: 0.12, b: 0.26)   // Dark night blue
            ]
            
            // Fall - Warm oranges, reds, and golden tones
            static let fallSunrise = [
                (r: 0.82, g: 0.40, b: 0.50),  // Deep magenta sunrise
                (r: 0.88, g: 0.50, b: 0.35),  // Rich burnt orange glow
                (r: 0.85, g: 0.60, b: 0.40)   // Deep amber morning
            ]
            static let fallDay = [
                (r: 0.28, g: 0.52, b: 0.82),  // Deep vibrant blue
                (r: 0.38, g: 0.58, b: 0.84),  // Rich fall blue
                (r: 0.48, g: 0.65, b: 0.86)   // Bright fall sky
            ]
            static let fallAfternoon = [
                (r: 0.30, g: 0.55, b: 0.81),  // Deep afternoon blue
                (r: 0.40, g: 0.61, b: 0.83),  // Rich afternoon
                (r: 0.50, g: 0.67, b: 0.85)   // Bright afternoon
            ]
            static let fallSunset = [
                (r: 0.85, g: 0.45, b: 0.30),  // Rich burnt sienna sunset
                (r: 0.88, g: 0.58, b: 0.28),  // Deep gold
                (r: 0.85, g: 0.65, b: 0.35)   // Rich amber
            ]
            static let fallEvening = [
                (r: 0.15, g: 0.10, b: 0.24),  // Deep plum evening
                (r: 0.22, g: 0.15, b: 0.30),  // Rich purple evening
                (r: 0.25, g: 0.18, b: 0.34)   // Dark evening purple
            ]
            static let fallMidnight = [
                (r: 0.05, g: 0.03, b: 0.12),  // Very deep plum midnight
                (r: 0.08, g: 0.05, b: 0.18),  // Deep purple-gray
                (r: 0.12, g: 0.08, b: 0.22)   // Dark night purple
            ]
            
            // Winter - Cool grays and icy blues
            static let winterSunrise = [
                (r: 0.80, g: 0.55, b: 0.65),  // Deep cool rose sunrise
                (r: 0.82, g: 0.62, b: 0.58),  // Rich coral glow
                (r: 0.80, g: 0.68, b: 0.62)   // Icy pink morning
            ]
            static let winterDay = [
                (r: 0.28, g: 0.52, b: 0.82),  // Deep icy sky blue
                (r: 0.38, g: 0.60, b: 0.85),  // Rich icy blue
                (r: 0.48, g: 0.66, b: 0.87)   // Bright winter sky
            ]
            static let winterAfternoon = [
                (r: 0.30, g: 0.55, b: 0.81),  // Deep afternoon blue
                (r: 0.40, g: 0.62, b: 0.84),  // Rich icy afternoon
                (r: 0.50, g: 0.68, b: 0.86)   // Bright winter afternoon
            ]
            static let winterSunset = [
                (r: 0.80, g: 0.62, b: 0.50),  // Deep cool amber sunset
                (r: 0.78, g: 0.65, b: 0.55),  // Rich slate gold
                (r: 0.75, g: 0.68, b: 0.58)   // Deep icy bronze
            ]
            static let winterEvening = [
                (r: 0.10, g: 0.14, b: 0.28),  // Deep steel evening
                (r: 0.16, g: 0.20, b: 0.34),  // Rich steel evening
                (r: 0.20, g: 0.24, b: 0.38)   // Dark evening steel
            ]
            static let winterMidnight = [
                (r: 0.02, g: 0.04, b: 0.12),  // Very deep midnight blue
                (r: 0.05, g: 0.08, b: 0.18),  // Deep steel blue
                (r: 0.08, g: 0.12, b: 0.22)   // Dark night steel
            ]
        }
        
        /// Cloud density by season
        enum CloudConfig {
            static let springDensity = 0.6   // Moderate clouds
            static let summerDensity = 0.8   // Many clouds
            static let fallDensity = 0.7     // Moderate-heavy
            static let winterDensity = 0.4   // Sparse clouds
        }
        
        /// Star visibility by season
        enum StarConfig {
            static let springVisibility = 0.7  // Moderate stars
            static let summerVisibility = 0.5  // Fewer stars (longer days)
            static let fallVisibility = 0.8    // More stars
            static let winterVisibility = 1.0  // Maximum stars (longer nights)
        }
    }
}

