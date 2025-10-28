//
//  AppSettings.swift
//  Peony
//
//  Centralized UserDefaults management with type safety
//  Created during modularity refactor - Phase 1
//

import Foundation

/// Property wrapper for type-safe UserDefaults access
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

/// Centralized application settings with type-safe access
/// Replaces scattered UserDefaults.standard calls throughout the app
enum AppSettings {
    
    // MARK: - Onboarding
    
    @UserDefault(key: "hasSeenOnboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool
    
    // MARK: - AI Features
    
    @UserDefault(key: "aiMoodDetectionEnabled", defaultValue: true)
    static var aiMoodDetectionEnabled: Bool
    
    @UserDefault(key: "aiSeedSuggestionsEnabled", defaultValue: true)
    static var aiSeedSuggestionsEnabled: Bool
    
    @UserDefault(key: "aiThemeAnalysisEnabled", defaultValue: true)
    static var aiThemeAnalysisEnabled: Bool
    
    @UserDefault(key: "aiPromptFrequency", defaultValue: "daily")
    static var aiPromptFrequency: String
    
    // MARK: - Notifications
    
    @UserDefault(key: "wateringRemindersEnabled", defaultValue: true)
    static var wateringRemindersEnabled: Bool
    
    @UserDefault(key: "wateringReminderHour", defaultValue: 9)
    static var wateringReminderHour: Int
    
    @UserDefault(key: "wateringReminderMinute", defaultValue: 0)
    static var wateringReminderMinute: Int
    
    @UserDefault(key: "weeklyCheckinEnabled", defaultValue: true)
    static var weeklyCheckinEnabled: Bool
    
    @UserDefault(key: "weeklyCheckinWeekday", defaultValue: 1)
    static var weeklyCheckinWeekday: Int
    
    @UserDefault(key: "weeklyCheckinHour", defaultValue: 10)
    static var weeklyCheckinHour: Int
    
    @UserDefault(key: "weeklyCheckinMinute", defaultValue: 0)
    static var weeklyCheckinMinute: Int
    
    // MARK: - Prompt System
    
    /// Last date a prompt was shown
    static var lastPromptDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastPromptDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPromptDate")
        }
    }
    
    @UserDefault(key: "lastPromptID", defaultValue: "")
    static var lastPromptID: String
    
    /// Array of recently shown prompt IDs
    static var recentPromptIDs: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "recentPromptIDs") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "recentPromptIDs")
        }
    }
    
    /// Array of prompt IDs user has responded to
    static var respondedPromptIDs: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "respondedPromptIDs") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "respondedPromptIDs")
        }
    }
    
    // MARK: - Seed Suggestions
    
    /// Array of note IDs that have been suggested for seed conversion
    static var suggestedNoteIDs: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "suggestedNoteIDs") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "suggestedNoteIDs")
        }
    }
    
    /// Array of note IDs that have been converted to seeds
    static var convertedNoteIDs: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "convertedNoteIDs") ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "convertedNoteIDs")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Register default values for all settings
    /// Called on app launch to ensure defaults are set
    static func registerDefaults() {
        let defaults: [String: Any] = [
            "hasSeenOnboarding": false,
            "aiMoodDetectionEnabled": true,
            "aiSeedSuggestionsEnabled": true,
            "aiThemeAnalysisEnabled": true,
            "aiPromptFrequency": "daily",
            "wateringRemindersEnabled": true,
            "wateringReminderHour": 9,
            "wateringReminderMinute": 0,
            "weeklyCheckinEnabled": true,
            "weeklyCheckinWeekday": 1,
            "weeklyCheckinHour": 10,
            "weeklyCheckinMinute": 0,
            "lastPromptID": "",
            "recentPromptIDs": [],
            "respondedPromptIDs": [],
            "suggestedNoteIDs": [],
            "convertedNoteIDs": []
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    /// Reset all settings to defaults (for testing or user request)
    static func resetToDefaults() {
        let keys = [
            "hasSeenOnboarding",
            "aiMoodDetectionEnabled",
            "aiSeedSuggestionsEnabled",
            "aiThemeAnalysisEnabled",
            "aiPromptFrequency",
            "wateringRemindersEnabled",
            "wateringReminderHour",
            "wateringReminderMinute",
            "weeklyCheckinEnabled",
            "weeklyCheckinWeekday",
            "weeklyCheckinHour",
            "weeklyCheckinMinute",
            "lastPromptDate",
            "lastPromptID",
            "recentPromptIDs",
            "respondedPromptIDs",
            "suggestedNoteIDs",
            "convertedNoteIDs"
        ]
        
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        registerDefaults()
    }
}

