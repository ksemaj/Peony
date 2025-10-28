//
//  CreateNoteView.swift
//  Peony
//
//  Created for version 2.0 (updated in v2.6)
//

import SwiftUI
import SwiftData

struct CreateNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    @FocusState private var isFocused: Bool
    @State private var showSeedSuggestionToast = false
    @State private var createdNote: JournalEntry?
    @State private var showingPlantSeedSheet = false

    // Optional prompt text to display above editor (v2.6)
    let promptText: String?

    init(promptText: String? = nil) {
        self.promptText = promptText
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Emoji indicator
                    Text("📝")
                        .font(.system(size: 44))
                        .padding(.top, 16)

                    Text("Journal Entry")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    // Show prompt if provided
                    if let prompt = promptText {
                        VStack(spacing: 8) {
                            HStack {
                                Text("💭 Prompt")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                    .textCase(.uppercase)
                                Spacer()
                            }

                            Text(prompt)
                                .font(.body)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Text editor
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text(promptText != nil ? "Write your thoughts..." : "What's on your mind?")
                                .font(.body)
                                .foregroundColor(.secondary.opacity(0.5))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                                .allowsHitTesting(false)
                        }

                        TextEditor(text: $content)
                            .focused($isFocused)
                            .font(.body)
                            .foregroundColor(.black)
                            .tint(.green)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 200)
                            .padding(4)
                    }
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(content.isEmpty ? .secondary : .green)
                    .disabled(content.isEmpty)
                }
            }
            .onAppear {
                isFocused = true
            }
            .sheet(isPresented: $showingPlantSeedSheet) {
                if let note = createdNote {
                    PlantSeedView(prefilledNote: note)
                        .onDisappear {
                            // Dismiss the CreateNoteView after the sheet closes
                            showSeedSuggestionToast = false
                            dismiss()
                        }
                }
            }
            .overlay {
                // Seed suggestion toast (only during free-writing)
                if showSeedSuggestionToast, let note = createdNote {
                    SeedSuggestionToast(
                        note: note,
                        onPlantSeed: {
                            showSeedSuggestionToast = false
                            showingPlantSeedSheet = true
                        },
                        onDismiss: {
                            showSeedSuggestionToast = false
                            dismiss()
                        },
                        onJustDismiss: {
                            showSeedSuggestionToast = false
                            dismiss()
                        }
                    )
                }
            }
        }
    }

    func saveNote() {
        let note = JournalEntry(content: content)
        note.detectAndSetMood()  // Detect mood after creation
        modelContext.insert(note)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Check if we should show seed suggestion toast
        // Only show during free-writing (no prompt text)
        if promptText == nil && SeedSuggestionEngine.shouldSuggestAsSeed(note) {
            createdNote = note
            SeedSuggestionEngine.markSuggested(note.id)
            showSeedSuggestionToast = true
        } else {
            dismiss()
        }
    }
}

#Preview {
    CreateNoteView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
