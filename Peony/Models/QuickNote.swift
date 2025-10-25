//
//  QuickNote.swift
//  Peony
//
//  Created for version 2.0
//

import Foundation
import SwiftData

@Model
class QuickNote {
    var id: UUID
    var content: String
    var createdDate: Date
    var tags: [String] // For future organization
    
    // AI features (v2.5 - Future)
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
}

