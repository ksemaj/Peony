//
//  NoteDetailView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {
    let note: JournalEntry
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingPlantSeedSheet = false
    @State private var seedTitle = ""
    
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
                
                // Plant as Seed button (v2.5 Week 4)
                if SeedSuggestionEngine.shouldSuggestAsSeed(note) {
                    Button {
                        showingPlantSeedSheet = true
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    } label: {
                        HStack {
                            Text("🌱")
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Plant This as a Seed")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Turn this entry into a growing journal seed")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.top, 4)
                }
                
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
        .navigationTitle("Entry")
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
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                modelContext.delete(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this entry? This action cannot be undone.")
        }
        .sheet(isPresented: $showingPlantSeedSheet) {
            plantSeedSheet
        }
    }
    
    // MARK: - Plant Seed Sheet
    
    var plantSeedSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("🌱")
                        .font(.system(size: 44))
                    
                    Text("Plant as Seed")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Your entry will grow into a beautiful flower over 45 days. Daily watering will speed up the growth!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Title input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Seed Title")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    TextField("Enter a title for your seed", text: $seedTitle)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        plantSeed()
                    } label: {
                        Text("Plant Seed 🌱")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(seedTitle.isEmpty ? Color.gray : Color.green)
                            .cornerRadius(12)
                    }
                    .disabled(seedTitle.isEmpty)
                    
                    Button {
                        showingPlantSeedSheet = false
                        seedTitle = ""
                    } label: {
                        Text("Cancel")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Helper Methods
    
    func plantSeed() {
        // Mark as suggested to avoid re-suggesting
        SeedSuggestionEngine.markSuggested(note.id)
        
        // Convert to seed
        let _ = note.convertToSeed(context: modelContext, title: seedTitle)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Close sheets and return to notes list
        showingPlantSeedSheet = false
        seedTitle = ""
        dismiss()
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: JournalEntry(content: "This is a sample note with some content to preview."))
    }
    .modelContainer(for: JournalEntry.self, inMemory: true)
}

