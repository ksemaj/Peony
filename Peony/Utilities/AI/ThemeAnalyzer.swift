//
//  ThemeAnalyzer.swift
//  Peony
//
//  Created for version 2.5 - AI Features (Week 3)
//

import Foundation

/// Analyzes notes to extract recurring themes using keyword frequency analysis
/// Privacy-first: All processing happens on-device
struct ThemeAnalyzer {
    
    // MARK: - Public Types
    
    struct Theme: Identifiable, Equatable {
        let id = UUID()
        let word: String
        let count: Int
    }
    
    enum Timeframe {
        case week
        case month
        case allTime
        
        var description: String {
            switch self {
            case .week: return "This Week"
            case .month: return "This Month"
            case .allTime: return "All Time"
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// Analyze notes and extract common themes
    /// - Parameters:
    ///   - notes: Array of JournalEntry objects to analyze
    ///   - timeframe: Time period to analyze (week, month, all time)
    ///   - limit: Maximum number of themes to return (default: 10)
    /// - Returns: Array of themes sorted by frequency
    static func analyzeThemes(in notes: [JournalEntry], timeframe: Timeframe = .month, limit: Int = 10) -> [Theme] {
        // Filter notes by timeframe
        let filteredNotes = filterNotes(notes, by: timeframe)
        
        guard !filteredNotes.isEmpty else { return [] }
        
        // Extract and count words
        var wordFrequency: [String: Int] = [:]
        
        for note in filteredNotes {
            let words = extractMeaningfulWords(from: note.content)
            for word in words {
                wordFrequency[word, default: 0] += 1
            }
        }
        
        // Convert to Theme objects and sort by frequency
        let themes = wordFrequency.map { Theme(word: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
            .prefix(limit)
        
        return Array(themes)
    }
    
    // MARK: - Private Methods
    
    /// Filter notes by timeframe
    private static func filterNotes(_ notes: [JournalEntry], by timeframe: Timeframe) -> [JournalEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeframe {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            return notes.filter { $0.createdDate >= weekAgo }
            
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return notes.filter { $0.createdDate >= monthAgo }
            
        case .allTime:
            return notes
        }
    }
    
    /// Extract meaningful words from text
    private static func extractMeaningfulWords(from text: String) -> [String] {
        // Convert to lowercase and split into words
        let words = text.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }
        
        // Filter meaningful words
        return words.filter { word in
            // Must be 3+ characters
            guard word.count >= 3 else { return false }
            
            // Not a stop word
            guard !stopWords.contains(word) else { return false }
            
            // Contains only letters
            guard word.allSatisfy({ $0.isLetter }) else { return false }
            
            return true
        }
    }
    
    // MARK: - Stop Words
    
    /// Common English stop words to filter out
    private static let stopWords: Set<String> = [
        // Articles
        "the", "a", "an",
        
        // Pronouns
        "i", "you", "he", "she", "it", "we", "they", "me", "him", "her", "us", "them",
        "my", "your", "his", "her", "its", "our", "their", "mine", "yours", "hers", "ours", "theirs",
        "this", "that", "these", "those", "who", "what", "which", "whom", "whose",
        
        // Prepositions
        "in", "on", "at", "to", "for", "of", "from", "with", "by", "about", "into", "through",
        "during", "before", "after", "above", "below", "between", "under", "over",
        
        // Conjunctions
        "and", "but", "or", "nor", "so", "yet", "for",
        
        // Verbs (common)
        "is", "am", "are", "was", "were", "be", "been", "being",
        "have", "has", "had", "do", "does", "did", "will", "would", "could", "should",
        "may", "might", "must", "can", "shall",
        
        // Adverbs
        "very", "really", "just", "too", "also", "well", "then", "now", "here", "there",
        "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most",
        "some", "such", "no", "not", "only", "own", "same", "than", "then",
        
        // Other common words
        "about", "get", "got", "make", "made", "thing", "things", "way", "went", "put",
        "see", "saw", "take", "took", "want", "wanted", "know", "knew", "think", "thought",
        "look", "looked", "come", "came", "give", "gave", "keep", "kept", "let",
        "begin", "began", "seem", "seemed", "help", "helped", "talk", "talked", "turn", "turned",
        "start", "started", "show", "showed", "hear", "heard", "play", "played", "run", "ran",
        "move", "moved", "like", "liked", "live", "lived", "believe", "believed", "hold", "held",
        "bring", "brought", "happen", "happened", "write", "wrote", "sit", "sat", "stand", "stood",
        "lose", "lost", "pay", "paid", "meet", "met", "include", "included", "continue", "continued",
        
        // Journaling-specific common words
        "today", "yesterday", "tomorrow", "day", "week", "month", "year", "time",
        "feel", "felt", "feeling", "feelings", "think", "thinking", "thought", "thoughts"
    ]
}


