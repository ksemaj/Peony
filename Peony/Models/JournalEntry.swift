//
//  JournalEntry.swift
//  Peony
//
//  Created for version 2.0 (renamed from QuickNote in v2.6)
//

import Foundation
import SwiftData

@Model
class JournalEntry {
    var id: UUID
    var content: String
    var createdDate: Date
    var tags: [String] // For future organization
    
    // AI features (v2.5 - On-Device)
    var detectedMood: String? // "reflective", "joyful", "thoughtful", etc.
    
    init(content: String, createdDate: Date = Date()) {
        self.id = UUID()
        self.content = content
        self.createdDate = createdDate
        self.tags = []
        self.detectedMood = nil
    }
    
    // MARK: - Computed Properties
    
    /// Preview text (first 100 characters)
    var preview: String {
        if content.count <= 100 {
            return content
        }
        return String(content.prefix(100)) + "..."
    }
    
    /// Word count
    var wordCount: Int {
        content.split(separator: " ").count
    }
    
    /// Character count
    var characterCount: Int {
        content.count
    }
    
    /// Formatted date for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdDate)
    }
    
    // MARK: - AI Methods
    
    /// Detect and set mood based on content
    /// Uses on-device NaturalLanguage framework for privacy
    func detectAndSetMood() {
        // Only detect if mood detection is enabled
        let isEnabled = AppSettings.aiMoodDetectionEnabled
        
        guard isEnabled else {
            return
        }
        
        self.detectedMood = MoodDetector.detectMood(in: content)
    }
    
    // MARK: - Seed Conversion (v2.5 Week 4)

    /// Convert this JournalEntry into a JournalSeed
    /// - Parameters:
    ///   - context: The ModelContext to insert the new seed into
    ///   - title: Title for the new seed
    ///   - imageData: Optional image data for the seed
    /// - Returns: The newly created JournalSeed
    func convertToSeed(context: ModelContext, title: String, imageData: Data? = nil) -> JournalSeed {
        // Create new seed with this note's content
        let seed = JournalSeed(content: content, title: title, imageData: imageData)
        
        // Insert into context
        context.insert(seed)
        
        // Mark as converted
        SeedSuggestionEngine.markConverted(self.id)
        
        return seed
    }
}

