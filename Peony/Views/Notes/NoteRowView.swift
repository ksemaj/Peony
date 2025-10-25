//
//  NoteRowView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI

struct NoteRowView: View {
    let note: QuickNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date
            Text(note.createdDate, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
            
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
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Show mood emoji if detected (future AI feature)
                if let mood = note.detectedMood {
                    Text(moodEmoji(mood))
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
    
    func moodEmoji(_ mood: String) -> String {
        switch mood {
        case "joyful": return "😊"
        case "reflective": return "🤔"
        case "grateful": return "🙏"
        case "peaceful": return "😌"
        case "thoughtful": return "💭"
        default: return "✨"
        }
    }
}

#Preview {
    NoteRowView(note: QuickNote(content: "This is a sample note with some content to preview how it looks in the list view. It should show the first few lines."))
        .padding()
}

