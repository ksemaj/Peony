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
        
        /// Seasonal sky color configurations
        enum SeasonalPalettes {
            // Spring - Fresh pastels with hints of pink and green
            static let springPreDawn = [
                (r: 0.10, g: 0.12, b: 0.28),  // Deep indigo (still night)
                (r: 0.15, g: 0.18, b: 0.35),  // Dark purple-blue
                (r: 0.20, g: 0.24, b: 0.42)   // Rich blue
            ]
            static let springDawn = [
                (r: 0.20, g: 0.30, b: 0.55),  // Deep twilight blue (saturated)
                (r: 0.30, g: 0.45, b: 0.70),  // Rich dawn blue  
                (r: 0.40, g: 0.60, b: 0.85)   // Vibrant morning blue
            ]
            static let springDay = [
                (r: 0.35, g: 0.65, b: 0.90),  // Rich sky blue (much more saturated)
                (r: 0.45, g: 0.70, b: 0.92),  // Bright sky blue
                (r: 0.55, g: 0.75, b: 0.95)   // Lighter sky blue
            ]
            static let springDusk = [
                (r: 0.95, g: 0.88, b: 0.92),  // Rose pink
                (r: 0.95, g: 0.90, b: 0.82),  // Peach glow
                (r: 0.92, g: 0.94, b: 0.90)   // Soft green-cream
            ]
            static let springNight = [
                (r: 0.08, g: 0.10, b: 0.25),  // Deep indigo night
                (r: 0.12, g: 0.15, b: 0.32),  // Dark purple-blue
                (r: 0.18, g: 0.22, b: 0.38)   // Night blue
            ]
            
            // Summer - Vibrant blues with warm highlights
            static let summerPreDawn = [
                (r: 0.12, g: 0.15, b: 0.32),  // Deep navy (still night)
                (r: 0.18, g: 0.22, b: 0.40),  // Dark midnight blue
                (r: 0.25, g: 0.30, b: 0.48)   // Rich navy
            ]
            static let summerDawn = [
                (r: 0.25, g: 0.35, b: 0.60),  // Deep dawn blue (saturated)
                (r: 0.35, g: 0.50, b: 0.75),  // Rich morning blue
                (r: 0.45, g: 0.65, b: 0.88)   // Bright dawn sky
            ]
            static let summerDay = [
                (r: 0.30, g: 0.60, b: 0.95),  // Vibrant saturated sky blue
                (r: 0.40, g: 0.68, b: 0.96),  // Bright summer blue
                (r: 0.50, g: 0.75, b: 0.97)   // Light summer sky
            ]
            static let summerDusk = [
                (r: 0.98, g: 0.80, b: 0.70),  // Warm orange
                (r: 0.95, g: 0.88, b: 0.75),  // Golden hour
                (r: 0.90, g: 0.92, b: 0.88)   // Warm gray
            ]
            static let summerNight = [
                (r: 0.10, g: 0.12, b: 0.30),  // Deep navy night
                (r: 0.15, g: 0.18, b: 0.36),  // Dark night blue
                (r: 0.22, g: 0.25, b: 0.42)   // Night blue
            ]
            
            // Fall - Warm oranges, reds, and golden tones
            static let fallPreDawn = [
                (r: 0.15, g: 0.10, b: 0.25),  // Deep plum (still night)
                (r: 0.22, g: 0.16, b: 0.32),  // Dark purple
                (r: 0.30, g: 0.24, b: 0.40)   // Rich mauve
            ]
            static let fallDawn = [
                (r: 0.28, g: 0.32, b: 0.52),  // Deep purple-blue twilight (saturated)
                (r: 0.38, g: 0.48, b: 0.68),  // Rich dawn purple-blue
                (r: 0.48, g: 0.62, b: 0.80)   // Bright dawn sky
            ]
            static let fallDay = [
                (r: 0.40, g: 0.62, b: 0.88),  // Rich blue-gray (much more saturated)
                (r: 0.50, g: 0.68, b: 0.90),  // Bright fall blue
                (r: 0.60, g: 0.75, b: 0.92)   // Light fall sky
            ]
            static let fallDusk = [
                (r: 0.98, g: 0.75, b: 0.60),  // Deep orange
                (r: 0.98, g: 0.85, b: 0.70),  // Golden orange
                (r: 0.95, g: 0.90, b: 0.82)   // Warm cream
            ]
            static let fallNight = [
                (r: 0.12, g: 0.08, b: 0.24),  // Deep plum night
                (r: 0.18, g: 0.14, b: 0.30),  // Dark purple-gray
                (r: 0.24, g: 0.20, b: 0.36)   // Night purple
            ]
            
            // Winter - Cool grays and icy blues
            static let winterPreDawn = [
                (r: 0.08, g: 0.12, b: 0.28),  // Deep midnight blue (still night)
                (r: 0.14, g: 0.20, b: 0.36),  // Dark steel
                (r: 0.22, g: 0.28, b: 0.44)   // Rich steel blue
            ]
            static let winterDawn = [
                (r: 0.22, g: 0.32, b: 0.58),  // Deep steel twilight (saturated)
                (r: 0.32, g: 0.48, b: 0.72),  // Rich slate blue
                (r: 0.42, g: 0.62, b: 0.82)   // Vibrant dawn blue
            ]
            static let winterDay = [
                (r: 0.38, g: 0.62, b: 0.88),  // Cool vibrant sky blue
                (r: 0.48, g: 0.70, b: 0.92),  // Bright icy blue
                (r: 0.58, g: 0.76, b: 0.94)   // Light winter sky
            ]
            static let winterDusk = [
                (r: 0.88, g: 0.85, b: 0.92),  // Cool lavender
                (r: 0.92, g: 0.90, b: 0.94),  // Icy purple
                (r: 0.90, g: 0.92, b: 0.95)   // Cool blue-gray
            ]
            static let winterNight = [
                (r: 0.06, g: 0.10, b: 0.22),  // Deep midnight blue
                (r: 0.12, g: 0.16, b: 0.28),  // Dark steel blue
                (r: 0.18, g: 0.22, b: 0.34)   // Night steel
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

