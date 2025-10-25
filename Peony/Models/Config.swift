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
    static let wateringBonus = 1.0 // percentage
    static let maxGrowthPercentage = 100.0
    
    // Garden Layout
    static let seedsPerBed = 9
    
    // App Info
    static let appVersion = "1.2.0"
    // TODO: Replace with actual URLs before App Store submission
    static let privacyPolicyURL = "https://example.com/privacy"  // FIXME: Replace before release
    static let supportURL = "https://example.com/support"  // FIXME: Replace before release
    
    // AI Settings (Future Implementation)
    enum AI {
        static var provider: AIProvider = .none
        // ⚠️ SECURITY WARNING: Never store API keys in UserDefaults or code!
        // Use Keychain for sensitive data. See SecureStorage utility in Phase 3.
        static var openAIKey: String? = nil  // TODO: Move to Keychain
        static var claudeKey: String? = nil  // TODO: Move to Keychain
        static var useOnDeviceML = true
    }
}

enum AIProvider: String, CaseIterable {
    case none = "None"
    case openAI = "OpenAI"
    case claude = "Claude"
    case appleCoreML = "On-Device"
}

