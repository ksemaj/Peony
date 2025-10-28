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
    let onJustDismiss: () -> Void  // For "Not Now" - only dismiss toast
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background overlay
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissToast(shouldDismiss: true)
                    }
                    .transition(.opacity)
                    .zIndex(1)
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
                            dismissToast(shouldDismiss: false)
                            onJustDismiss()
                        } label: {
                            Text("Not Now")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(1.0))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Plant seed button
                        Button {
                            dismissToast(shouldDismiss: false)
                            onPlantSeed()  // Call immediately to show sheet
                        } label: {
                            Text("Plant It")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green.opacity(1.0))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(24)
                .background(Color.white.opacity(1.0))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .transition(.scale.combined(with: .opacity))
                .zIndex(2)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPresented = true
            }
        }
    }
    
    private func dismissToast(shouldDismiss: Bool = true) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPresented = false
        }
        if shouldDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onDismiss()
            }
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
                        },
                        onJustDismiss: {
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

