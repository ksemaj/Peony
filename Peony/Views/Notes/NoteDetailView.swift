//
//  NoteDetailView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI

struct NoteDetailView: View {
    let note: QuickNote
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Date header
                HStack {
                    Text(note.createdDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(note.createdDate, style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                // Content
                Text(note.content)
                    .font(.body)
                    .foregroundColor(.black)
                
                Spacer(minLength: 20)
                
                // Metadata card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Words:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(note.wordCount)")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Characters:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(note.characterCount)")
                            .foregroundColor(.gray)
                    }
                    
                    if let mood = note.detectedMood {
                        HStack {
                            Text("Mood:")
                                .foregroundColor(.black)
                            Spacer()
                            Text(mood.capitalized)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .font(.caption)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.green)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditNoteView(note: note)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: QuickNote(content: "This is a sample note with some content to preview."))
    }
    .modelContainer(for: QuickNote.self, inMemory: true)
}

