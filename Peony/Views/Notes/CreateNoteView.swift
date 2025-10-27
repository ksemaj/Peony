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

                VStack(spacing: 20) {
                    // Emoji indicator
                    Text("📝")
                        .font(.system(size: 60))
                        .padding(.top, 20)

                    Text("Journal Entry")
                        .font(.title2)
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
        }
    }

    func saveNote() {
        let note = JournalEntry(content: content)
        modelContext.insert(note)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        dismiss()
    }
}

#Preview {
    CreateNoteView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
