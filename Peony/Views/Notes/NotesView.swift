//
//  NotesView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuickNote.createdDate, order: .reverse) private var notes: [QuickNote]
    @State private var showingCreateNote = false
    
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
                    notesListView
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreateNote = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.green)
                    }
                }
            }
            .sheet(isPresented: $showingCreateNote) {
                CreateNoteView()
            }
        }
    }
    
    // MARK: - Empty State
    
    var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("📝")
                .font(.system(size: 80))
            
            VStack(spacing: 12) {
                Text("No notes yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text("Quick notes are perfect for\ndaily reflections and thoughts")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button {
                showingCreateNote = true
            } label: {
                Text("Write Your First Note")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.green, Color.green.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .padding(.top, 8)
            
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Notes List
    
    var notesListView: some View {
        ScrollView {
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
            .padding()
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    NotesView()
        .modelContainer(for: QuickNote.self, inMemory: true)
}

