//
//  NoteRowView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI

struct NoteRowView: View {
    let note: JournalEntry
    @State private var isPressed = false
    
    // Computed once instead of on every render (performance optimization)
    private var shouldSuggestAsSeed: Bool {
        SeedSuggestionEngine.shouldSuggestAsSeed(note)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date
            Text(note.createdDate, style: .date)
                .font(.caption)
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
            
            // Preview
            Text(note.preview)
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Metadata row
            HStack {
                Text("\(note.wordCount) words")
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                
                Spacer()
                
                // Show mood emoji if detected (v2.5 Week 1)
                if let mood = note.detectedMood {
                    Text(moodEmoji(mood))
                        .font(.caption)
                }
                
                // Seed suggestion badge (v2.5 Week 4)
                if shouldSuggestAsSeed {
                    HStack(spacing: 4) {
                        Text("🌱")
                            .font(.caption2)
                        Text("Plant as Seed")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.15))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: .black.opacity(isPressed ? 0.02 : 0.05), radius: isPressed ? 2 : 3, x: 0, y: 1)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    func moodEmoji(_ mood: String) -> String {
        MoodHelpers.emoji(for: mood)
    }
}

#Preview {
    NoteRowView(note: JournalEntry(content: "This is a sample note with some content to preview how it looks in the list view. It should show the first few lines."))
        .padding()
}

