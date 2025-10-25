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
    @State private var animateEmptyState = false
    
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
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        showingCreateNote = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.green)
                            .symbolEffect(.bounce, value: showingCreateNote)
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
                .scaleEffect(animateEmptyState ? 1.0 : 0.5)
                .opacity(animateEmptyState ? 1.0 : 0)
            
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
            .opacity(animateEmptyState ? 1.0 : 0)
            .offset(y: animateEmptyState ? 0 : 20)
            
            Button {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
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
    
    // MARK: - Notes List
    
    var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        NoteRowView(note: note)
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding()
            .padding(.bottom, 20)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: notes.count)
        }
    }
}

#Preview {
    NotesView()
        .modelContainer(for: QuickNote.self, inMemory: true)
}

