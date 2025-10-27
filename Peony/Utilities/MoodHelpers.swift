//
//  MoodHelpers.swift
//  Peony
//
//  Created as part of Phase 5 refactor - Code deduplication
//

import Foundation

/// Centralized mood emoji and display name utilities
/// Eliminates code duplication across NoteRowView, MoodDetector, etc.
struct MoodHelpers {
    
    // MARK: - Public Methods
    
    /// Get emoji representation for a mood
    /// - Parameter mood: The mood string (joyful, reflective, grateful, etc.)
    /// - Returns: Emoji string representing the mood
    static func emoji(for mood: String) -> String {
        switch mood {
        case "joyful":
            return "😊"
        case "reflective":
            return "🤔"
        case "grateful":
            return "🙏"
        case "peaceful":
            return "😌"
        case "thoughtful":
            return "💭"
        default:
            return "✨"
        }
    }
    
    /// Get display name for a mood
    /// - Parameter mood: The mood string
    /// - Returns: Capitalized display name
    static func displayName(for mood: String) -> String {
        mood.capitalized
    }
}


