//
//  SeedSuggestionEngine.swift
//  Peony
//
//  Created for version 2.5 - AI Features (Week 4)
//

import Foundation

/// Suggests converting Journal Entries to Seeds based on content quality
/// Criteria: meaningful sentiment + sufficient length
struct SeedSuggestionEngine {
    
    // MARK: - Constants
    
    private static let minimumWordCount = 150
    private static let suggestedNotesKey = "suggestedNoteIDs"
    private static let convertedNotesKey = "convertedNoteIDs"
    
    // MARK: - Public Methods
    
    /// Determine if a note should be suggested for seed conversion
    /// - Parameter note: The JournalEntry to evaluate
    /// - Returns: True if note qualifies for suggestion
    static func shouldSuggestAsSeed(_ note: JournalEntry) -> Bool {
        // Check if seed suggestions enabled
        let isEnabled = UserDefaults.standard.bool(forKey: AppConfig.AI.seedSuggestionsEnabledKey)
        print("🌱 Seed suggestions enabled: \(isEnabled)")
        guard isEnabled else {
            return false
        }
        
        // Check word count threshold
        print("🌱 Note word count: \(note.wordCount) (need \(minimumWordCount)+)")
        guard note.wordCount >= minimumWordCount else {
            return false
        }
        
        // Check if already suggested
        if hasBeenSuggested(note.id) {
            print("🌱 Already suggested")
            return false
        }
        
        // Check if already converted
        if hasBeenConverted(note.id) {
            print("🌱 Already converted")
            return false
        }
        
        // Check sentiment (meaningful moods)
        guard let mood = note.detectedMood else {
            print("🌱 No mood detected")
            return false // No mood detected
        }
        
        print("🌱 Note mood: \(mood)")
        
        // Only suggest reflective, grateful, or thoughtful notes
        // These tend to be more meaningful and seed-worthy
        let meaningfulMoods = ["reflective", "grateful", "thoughtful"]
        let qualifies = meaningfulMoods.contains(mood)
        print("🌱 Qualifies for seed: \(qualifies)")
        return qualifies
    }
    
    /// Mark a note as suggested
    /// - Parameter noteID: The UUID of the note
    static func markSuggested(_ noteID: UUID) {
        var suggested = getSuggestedNoteIDs()
        let idString = noteID.uuidString
        if !suggested.contains(idString) {
            suggested.append(idString)
            UserDefaults.standard.set(suggested, forKey: suggestedNotesKey)
        }
    }
    
    /// Mark a note as converted to seed
    /// - Parameter noteID: The UUID of the note
    static func markConverted(_ noteID: UUID) {
        var converted = getConvertedNoteIDs()
        let idString = noteID.uuidString
        if !converted.contains(idString) {
            converted.append(idString)
            UserDefaults.standard.set(converted, forKey: convertedNotesKey)
        }
    }
    
    /// Check if user has been shown this suggestion before
    /// - Parameter noteID: The UUID to check
    /// - Returns: True if already suggested
    static func hasBeenSuggested(_ noteID: UUID) -> Bool {
        let suggested = getSuggestedNoteIDs()
        let idString = noteID.uuidString
        return suggested.contains(idString)
    }
    
    /// Check if note has been converted to seed
    /// - Parameter noteID: The UUID to check
    /// - Returns: True if already converted
    static func hasBeenConverted(_ noteID: UUID) -> Bool {
        let converted = getConvertedNoteIDs()
        let idString = noteID.uuidString
        return converted.contains(idString)
    }
    
    // MARK: - Private Methods
    
    private static func getSuggestedNoteIDs() -> [String] {
        return UserDefaults.standard.stringArray(forKey: suggestedNotesKey) ?? []
    }
    
    private static func getConvertedNoteIDs() -> [String] {
        return UserDefaults.standard.stringArray(forKey: convertedNotesKey) ?? []
    }
}

