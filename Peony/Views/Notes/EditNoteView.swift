//
//  EditNoteView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct EditNoteView: View {
    let note: JournalEntry
    @Environment(\.dismiss) private var dismiss
    @State private var content: String
    @FocusState private var isFocused: Bool
    
    init(note: JournalEntry) {
        self.note = note
        _content = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Emoji indicator (decorative, fixed size is okay)
                    Text("📝")
                        .font(.system(size: 44))
                        .padding(.top, 16)
                    
                    Text("Edit Entry")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // Cap at xxxLarge for readability
                    
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("What's on your mind?")
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
            .navigationTitle("Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Cancel editing note")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(content.isEmpty ? .secondary : .green)
                    .disabled(content.isEmpty)
                    .accessibilityLabel(content.isEmpty ? "Save disabled. Enter content to enable" : "Save changes")
                    .accessibilityHint("Tap to save your edited journal entry")
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
    
    func saveChanges() {
        note.content = content
        
        // Re-detect mood after editing (v2.5)
        note.detectAndSetMood()
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
    }
}

#Preview {
    EditNoteView(note: JournalEntry(content: "Sample note content"))
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

