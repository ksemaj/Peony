//
//  ThemeChip.swift
//  Peony
//
//  Extracted from ThemesCard.swift - Modular Architecture Cleanup
//

import SwiftUI

/// Single theme chip display
struct ThemeChip: View {
    let theme: ThemeAnalyzer.Theme
    
    var body: some View {
        HStack(spacing: 4) {
            Text(theme.word.capitalized)
                .font(.caption)
                .fontWeight(.medium)
            
            Text("(\(theme.count))")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.pastelGreenLight.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ThemeChip(theme: ThemeAnalyzer.Theme(word: "gratitude", count: 12))
        .padding()
}


