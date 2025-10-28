//
//  WritingPrompt.swift
//  Peony
//
//  Created for version 2.5 - AI Features
//

import Foundation

/// Model for writing prompts that inspire journaling
struct WritingPrompt: Codable, Identifiable, Equatable {
    let id: String
    let text: String
    let category: PromptCategory
    let timeOfDay: [TimeOfDay]

    enum PromptCategory: String, Codable, CaseIterable {
        case reflection = "Reflection"
        case gratitude = "Gratitude"
        case goals = "Goals"
        case memories = "Memories"
        case feelings = "Feelings"
        case growth = "Growth"
    }

    enum TimeOfDay: String, Codable {
        case morning = "morning"
        case afternoon = "afternoon"
        case evening = "evening"
        case anytime = "anytime"
    }

    /// Check if prompt is appropriate for current time
    func isAppropriateForTime(_ hour: Int) -> Bool {
        // If prompt works anytime, always return true
        if timeOfDay.contains(.anytime) {
            return true
        }

        // Morning: 5am-11am
        if hour >= 5 && hour < 12 && timeOfDay.contains(.morning) {
            return true
        }

        // Afternoon: 12pm-5pm
        if hour >= 12 && hour < 17 && timeOfDay.contains(.afternoon) {
            return true
        }

        // Evening: 5pm-11pm
        if hour >= 17 && hour < 23 && timeOfDay.contains(.evening) {
            return true
        }

        // Late night/early morning: default to anytime prompts
        return false
    }
}
