//
//  NotesStatsView.swift
//  Peony
//
//  Created for version 2.0 - Phase 2.4
//

import SwiftUI
import SwiftData

struct NotesStatsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \JournalEntry.createdDate, order: .reverse) private var allNotes: [JournalEntry]
    
    // Computed statistics
    var totalNotes: Int {
        allNotes.count
    }
    
    var totalWords: Int {
        allNotes.reduce(0) { $0 + $1.wordCount }
    }
    
    var averageWords: Int {
        guard totalNotes > 0 else { return 0 }
        return totalWords / totalNotes
    }
    
    var notesThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return 0 }
        return allNotes.filter { $0.createdDate >= weekAgo }.count
    }
    
    var notesThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return 0 }
        return allNotes.filter { $0.createdDate >= monthAgo }.count
    }
    
    // Themes (v2.5 Week 3)
    var monthlyThemes: [ThemeAnalyzer.Theme] {
        ThemeAnalyzer.analyzeThemes(in: allNotes, timeframe: .month, limit: 8)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header emoji
                    Text("📊")
                        .font(.system(size: 44))
                        .padding(.top, 16)
                    
                    // Overall stats card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Writing Overview")
                            .font(.serifSubheadline)
                            .foregroundColor(.black)
                        
                        Divider()
                        
                        StatRow(label: "Total Entries", value: "\(totalNotes)")
                        StatRow(label: "Total Words", value: "\(totalWords)")
                        StatRow(label: "Average Words", value: "\(averageWords)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    
                    // Recent activity card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.serifSubheadline)
                            .foregroundColor(.black)
                        
                        Divider()
                        
                        StatRow(label: "This Week", value: "\(notesThisWeek) entries")
                        StatRow(label: "This Month", value: "\(notesThisMonth) entries")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    
                    // Common themes card (v2.5 Week 3)
                    if !monthlyThemes.isEmpty && AppSettings.aiThemeAnalysisEnabled {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Common Themes This Month")
                                .font(.serifSubheadline)
                                .foregroundColor(.black)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(monthlyThemes.prefix(8)) { theme in
                                    HStack {
                                        Text(theme.word.capitalized)
                                            .font(.body)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 4) {
                                            Text("\(theme.count)")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.green)
                                            
                                            // Visual bar
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.green.opacity(0.3))
                                                .frame(width: CGFloat(theme.count) * 8, height: 20)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }
                    
                    // Encouragement message
                    if totalNotes == 0 {
                        VStack(spacing: 12) {
                            Text("✨")
                                .font(.system(size: 32))
                            Text("Start writing to see your statistics!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(12)
                    } else {
                        VStack(spacing: 12) {
                            Text("🌱")
                                .font(.system(size: 32))
                            Text("Keep writing! Your thoughts are growing.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(12)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .background(
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}

// MARK: - Stat Row Component

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
    }
}

// MARK: - Preview

#Preview {
    NotesStatsView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

