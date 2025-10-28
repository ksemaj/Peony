//
//  SeedSuggestionToast.swift
//  Peony
//
//  Created for version 2.5 - Seed Suggestions Toast (Week 4)
//

import SwiftUI
import SwiftData

struct SeedSuggestionToast: View {
    let note: JournalEntry
    let onPlantSeed: () -> Void
    let onDismiss: () -> Void
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background overlay
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissToast()
                    }
                    .transition(.opacity)
            }
            
            // Toast card
            if isPresented {
                VStack(spacing: 16) {
                    // Emoji
                    Text("🌱")
                        .font(.system(size: 48))
                    
                    // Title
                    Text("Plant as a Seed?")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    // Description
                    Text("This thoughtful entry could become a growing journal seed!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Word count
                    Text("\(note.wordCount) words")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        // Dismiss button
                        Button {
                            dismissToast()
                        } label: {
                            Text("Not Now")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        
                        // Plant seed button
                        Button {
                            onPlantSeed()
                            dismissToast()
                        } label: {
                            Text("Plant It")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPresented = true
            }
        }
    }
    
    private func dismissToast() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showToast = true
        let sampleNote = JournalEntry(content: String(repeating: "This is a thoughtful and reflective entry with meaningful content. ", count: 30))
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2)
                
                if showToast {
                    SeedSuggestionToast(
                        note: sampleNote,
                        onPlantSeed: {
                            print("Plant seed tapped")
                        },
                        onDismiss: {
                            showToast = false
                        }
                    )
                }
            }
        }
    }
    
    return PreviewWrapper()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}

