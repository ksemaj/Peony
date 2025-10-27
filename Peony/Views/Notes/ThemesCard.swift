//
//  ThemesCard.swift
//  Peony
//
//  Created for version 2.5 - AI Features (Week 3)
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
                        .font(.subheadline)
                        .fontWeight(.semibold)
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

// MARK: - Theme Chip

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

// MARK: - Flow Layout

/// Custom layout that arranges views in a flowing grid
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let subviewSize = subview.sizeThatFits(.unspecified)
                
                if x + subviewSize.width > maxWidth && x > 0 {
                    // Move to next line
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, subviewSize.height)
                x += subviewSize.width + spacing
            }
            
            size = CGSize(width: maxWidth, height: y + lineHeight)
        }
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


