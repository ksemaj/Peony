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
    @State private var searchText = ""
    @State private var selectedFilter: TimeFilter = .all
    
    enum TimeFilter: String, CaseIterable {
        case all = "All Time"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
    }
    
    var filteredNotes: [QuickNote] {
        var result = notes
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { note in
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply time filter
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .thisWeek:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            result = result.filter { $0.createdDate >= weekAgo }
        case .thisMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            result = result.filter { $0.createdDate >= monthAgo }
        case .all:
            break
        }
        
        return result
    }
    
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
                    VStack(spacing: 0) {
                        // Filter chips
                        filterChipsView
                        
                        // Search result count
                        if !searchText.isEmpty || selectedFilter != .all {
                            resultCountView
                        }
                        
                        // Notes list
                        if filteredNotes.isEmpty {
                            noResultsView
                        } else {
                            notesListView
                        }
                    }
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
            .searchable(text: $searchText, prompt: "Search notes...")
        }
    }
    
    // MARK: - Filter Chips
    
    var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                            .foregroundColor(selectedFilter == filter ? .white : .green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedFilter == filter ?
                                    Color.green : Color.white.opacity(0.8)
                            )
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color.clear)
    }
    
    // MARK: - Result Count
    
    var resultCountView: some View {
        HStack {
            Text("\(filteredNotes.count) \(filteredNotes.count == 1 ? "note" : "notes")")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - No Results
    
    var noResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("🔍")
                .font(.system(size: 60))
            
            Text("No notes found")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("Try adjusting your search or filter")
                .font(.body)
                .foregroundColor(.gray)
            
            if !searchText.isEmpty || selectedFilter != .all {
                Button {
                    withAnimation {
                        searchText = ""
                        selectedFilter = .all
                    }
                } label: {
                    Text("Clear Filters")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            
            Spacer()
            Spacer()
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
                ForEach(Array(filteredNotes.enumerated()), id: \.element.id) { index, note in
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
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: filteredNotes.count)
        }
    }
}

#Preview {
    NotesView()
        .modelContainer(for: QuickNote.self, inMemory: true)
}

