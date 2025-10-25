//
//  EditNoteView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct EditNoteView: View {
    let note: QuickNote
    @Environment(\.dismiss) private var dismiss
    @State private var content: String
    @FocusState private var isFocused: Bool
    
    init(note: QuickNote) {
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
                
                VStack(spacing: 20) {
                    Text("📝")
                        .font(.system(size: 60))
                        .padding(.top, 20)
                    
                    Text("Edit Note")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
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
            .navigationTitle("Edit Note")
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
                        saveChanges()
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
    
    func saveChanges() {
        note.content = content
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
    }
}

#Preview {
    EditNoteView(note: QuickNote(content: "Sample note content"))
        .modelContainer(for: QuickNote.self, inMemory: true)
}

