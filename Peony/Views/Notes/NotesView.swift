//
//  NotesView.swift
//  Peony
//
//  Created for version 2.0 (redesigned in v2.6)
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.createdDate, order: .reverse) private var notes: [JournalEntry]
    @State private var showingCreateNote = false
    @State private var animateEmptyState = false
    @State private var showingStats = false
    @State private var showingExportSheet = false
    @State private var dailyPrompt: WritingPrompt?
    @State private var promptTextToUse: String?
    
    @Query(sort: \JournalSeed.plantedDate, order: .reverse) private var seeds: [JournalSeed]
    @Query(sort: \WateringStreak.lastWateredDate, order: .reverse) private var streaks: [WateringStreak]

    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background (consistent with seeds)
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if notes.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Two writing paths
                            writingPathsView

                            // Recent entries header
                            HStack {
                                Text("Recent Entries")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)

                            // Notes list
                            LazyVStack(spacing: 12) {
                                ForEach(notes) { note in
                                    NavigationLink {
                                        NoteDetailView(note: note)
                                    } label: {
                                        NoteRowView(note: note)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 12)
                    }
                }
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingStats = true
                    } label: {
                        Image(systemName: "chart.bar")
                            .foregroundColor(.green)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingExportSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.green)
                    }
                    .accessibilityLabel("Export data")
                    .accessibilityHint("Export all your journal entries to JSON file")
                }
            }
            .sheet(isPresented: $showingCreateNote) {
                CreateNoteView(promptText: promptTextToUse)
            }
            .sheet(isPresented: $showingExportSheet) {
                ExportDataView(seeds: seeds, entries: notes, streaks: streaks)
            }
            .onChange(of: showingCreateNote) { _, isShowing in
                // Clear prompt text when sheet is dismissed
                if !isShowing {
                    promptTextToUse = nil
                }
            }
            .sheet(isPresented: $showingStats) {
                NotesStatsView()
            }
            .onAppear {
                loadDailyPrompt()
            }
        }
    }

    // MARK: - Writing Paths

    var writingPathsView: some View {
        VStack(spacing: 12) {
            // Free Write Card
            Button {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                promptTextToUse = nil
                showingCreateNote = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text("✍️")
                                .font(.title2)
                            Text("Free Write")
                                .font(.headline)
                                .foregroundColor(.black)
                        }

                        Text("Express your thoughts freely")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: "arrow.right")
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }

            // Prompt Card
            if let prompt = dailyPrompt,
               AppSettings.aiPromptFrequency != "off" {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    promptTextToUse = prompt.text
                    showingCreateNote = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Text("💭")
                                    .font(.title2)
                                Text("Today's Prompt")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }

                            Text(prompt.text)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }

                        Spacer()

                        VStack {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.purple)

                            Spacer()

                            Button {
                                skipPrompt()
                            } label: {
                                Text("Skip")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Empty State

    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("📝")
                .font(.system(size: 48))
                .scaleEffect(animateEmptyState ? 1.0 : 0.5)
                .opacity(animateEmptyState ? 1.0 : 0)

            VStack(spacing: 10) {
                Text("Start Your Journal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Text("Choose free writing or a guided prompt\nto begin your reflection")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .opacity(animateEmptyState ? 1.0 : 0)
            .offset(y: animateEmptyState ? 0 : 20)

            // Writing paths in empty state
            VStack(spacing: 12) {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    promptTextToUse = nil
                    showingCreateNote = true
                } label: {
                    Text("✍️ Free Write")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 2)
                }

                if let prompt = dailyPrompt,
                   AppSettings.aiPromptFrequency != "off" {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        promptTextToUse = prompt.text
                        showingCreateNote = true
                    } label: {
                        VStack(spacing: 4) {
                            Text("💭 Use Today's Prompt")
                                .font(.headline)
                            Text("\"\(prompt.text)\"")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                        .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
            .scaleEffect(animateEmptyState ? 1.0 : 0.8)
            .opacity(animateEmptyState ? 1.0 : 0)

            Spacer()
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateEmptyState = true
            }
        }
    }

    // MARK: - Helper Methods

    /// Load daily prompt on appear
    private func loadDailyPrompt() {
        dailyPrompt = PromptGenerator.shared.getTodaysPrompt()
    }

    /// Skip to next prompt
    private func skipPrompt() {
        dailyPrompt = PromptGenerator.shared.getNewPrompt()
    }
}

#Preview {
    NotesView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
