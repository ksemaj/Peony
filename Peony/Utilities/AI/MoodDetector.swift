//
//  MoodDetector.swift
//  Peony
//
//  Created for version 2.5 - AI Features
//

import Foundation
import NaturalLanguage

/// Detects mood/sentiment from text using Apple's on-device NaturalLanguage framework
/// Privacy-first: All processing happens locally, no data sent to servers
class MoodDetector {
    
    // MARK: - Public Methods
    
    /// Detect mood from text content
    /// - Parameter text: The text to analyze
    /// - Returns: A mood string (joyful, grateful, reflective, thoughtful, peaceful) or nil if detection fails
    static func detectMood(in text: String) -> String? {
        // Require minimum content length for meaningful analysis
        guard text.count > 20 else {
            return nil
        }
        
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        // Get sentiment score for the entire text
        let (sentiment, _) = tagger.tag(
            at: text.startIndex,
            unit: .paragraph,
            scheme: .sentimentScore
        )
        
        // Convert sentiment tag to numeric score
        guard let scoreString = sentiment?.rawValue,
              let score = Double(scoreString) else {
            return nil
        }
        
        let mood = mapScoreToMood(score)
        return mood
    }
    
    /// Get mood emoji for display (now uses shared MoodHelpers)
    /// - Parameter mood: The mood string (joyful, grateful, etc.)
    /// - Returns: Emoji representing the mood
    static func moodEmoji(for mood: String) -> String {
        MoodHelpers.emoji(for: mood)
    }
    
    /// Get mood display name (now uses shared MoodHelpers)
    /// - Parameter mood: The mood string
    /// - Returns: Capitalized display name
    static func moodDisplayName(for mood: String) -> String {
        MoodHelpers.displayName(for: mood)
    }
    
    // MARK: - Private Methods
    
    /// Map sentiment score (-1.0 to 1.0) to a mood category
    /// - Parameter score: Sentiment score from NLTagger
    /// - Returns: Mood string
    private static func mapScoreToMood(_ score: Double) -> String {
        switch score {
        case 0.5...1.0:
            return "joyful"      // Very positive
        case 0.2..<0.5:
            return "grateful"    // Moderately positive
        case -0.2..<0.2:
            return "reflective"  // Neutral
        case -0.5..<(-0.2):
            return "thoughtful"  // Moderately negative/contemplative
        default:
            return "peaceful"    // Very negative or uncertain → reframe as peaceful
        }
    }
}

// MARK: - Mood Categories

/// Supported mood categories for journaling
enum MoodCategory: String, CaseIterable {
    case joyful = "joyful"
    case grateful = "grateful"
    case reflective = "reflective"
    case thoughtful = "thoughtful"
    case peaceful = "peaceful"
    
    var emoji: String {
        MoodDetector.moodEmoji(for: self.rawValue)
    }
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

