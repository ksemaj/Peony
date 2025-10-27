//
//  ThemesCard.swift
//  Peony
//
//  Created for version 2.5 - AI Features (Week 3)
//  Refactored - Modular Architecture Cleanup (extracted ThemeChip and FlowLayout)
//

import SwiftUI

struct ThemesCard: View {
    let themes: [ThemeAnalyzer.Theme]
    let timeframe: ThemeAnalyzer.Timeframe
    @Binding var isExpanded: Bool
    
    @State private var cardScale: CGFloat = 0.95
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header (tappable to expand/collapse)
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
                
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            } label: {
                HStack(spacing: 8) {
                    Text("🎨")
                        .font(.title3)
                    
                    Text("Your Themes \(timeframe.description)")
                        .font(.serifSubheadline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
            }
            .buttonStyle(.plain)
            
            // Themes content (collapsible)
            if isExpanded {
                if themes.isEmpty {
                    emptyStateView
                } else {
                    themesGridView
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(cardScale)
        .opacity(cardOpacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
    
    // MARK: - Empty State
    
    var emptyStateView: some View {
        VStack(spacing: 8) {
            Text("Not enough notes yet")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Keep journaling to discover your themes")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    // MARK: - Themes Grid
    
    var themesGridView: some View {
        FlowLayout(spacing: 8) {
            ForEach(themes) { theme in
                ThemeChip(theme: theme)
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    ThemesCard(
        themes: [
            ThemeAnalyzer.Theme(word: "gratitude", count: 12),
            ThemeAnalyzer.Theme(word: "family", count: 8),
            ThemeAnalyzer.Theme(word: "work", count: 7),
            ThemeAnalyzer.Theme(word: "health", count: 6),
            ThemeAnalyzer.Theme(word: "friends", count: 5)
        ],
        timeframe: .month,
        isExpanded: .constant(true)
    )
    .padding()
    .background(
        LinearGradient(
            colors: [Color.ivoryLight, Color.pastelGreenLight],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}


