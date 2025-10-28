//
//  SeedDetailView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI
import SwiftData

/// Detailed view of a seed showing growth stats, watering, and content
struct SeedDetailView: View {
    let seed: JournalSeed
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullScreenImage = false
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showWateringAnimation = false
    @State private var showWateringSuccess = false
    @State private var wateringScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    PlantView(growthStage: seed.growthStage, size: 100)

                    Text("\(Int(seed.growthPercentage))% Grown")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)

                    ProgressView(value: seed.growthPercentage, total: 100)
                        .tint(.warmGold)
                        .frame(maxWidth: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.cardLight)
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Planted:")
                            .foregroundColor(.black)
                        Spacer()
                        Text(seed.plantedDate, style: .date)
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Days growing:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(Calendar.current.dateComponents([.day], from: seed.plantedDate, to: Date()).day ?? 0)")
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Growth stage:")
                            .foregroundColor(.black)
                        Spacer()
                        HStack(spacing: 6) {
                            PlantView(growthStage: seed.growthStage, size: 20)
                            Text(seed.growthStage.displayName)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        Text("Times watered:")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(seed.timesWatered)")
                            .foregroundColor(.black)
                    }
                    
                    // Streak information
                    if seed.currentStreakCount > 0 {
                        Divider()
                        
                        HStack {
                            HStack(spacing: 4) {
                                Text("🔥")
                                Text("Current streak:")
                            }
                            .foregroundColor(.black)
                            Spacer()
                            Text("\(seed.currentStreakCount) days")
                                .foregroundColor(.orange)
                                .fontWeight(.semibold)
                        }
                        
                        HStack {
                            Text("Streak bonus:")
                                .foregroundColor(.black)
                            Spacer()
                            let multiplier = seed.wateringStreak?.streakMultiplier ?? 1.0
                            Text("+\(String(format: "%.1f", multiplier))% per watering")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    if seed.longestStreakCount > 0 {
                        HStack {
                            Text("Longest streak:")
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(seed.longestStreakCount) days")
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }
                }
                .padding()
                .background(Color.cardLight)
                .cornerRadius(16)

                if seed.growthPercentage < 100 {
                    WateringButton(
                        seed: seed,
                        canWater: seed.canWaterToday,
                        showAnimation: $showWateringAnimation,
                        onWater: {
                            // Create watering streak if needed and insert into context
                            if seed.wateringStreak == nil {
                                let newStreak = WateringStreak(seedId: seed.id)
                                modelContext.insert(newStreak)
                                seed.wateringStreak = newStreak
                            }
                            
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                                seed.water()
                                showWateringAnimation = true
                            }
                            
                            // Show success view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showWateringSuccess = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showWateringAnimation = false
                                }
                            }
                        }
                    )
                }
                
                if let imageData = seed.imageData, let image = imageData.asUIImage {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Memory")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Button {
                            showingFullScreenImage = true
                        } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardLight)
                    .cornerRadius(16)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Entry")
                        .font(.serifSubheadline)
                        .foregroundColor(.black)
                    
                    if seed.growthPercentage >= 100 {
                        Text(seed.content)
                            .font(.body)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("Your full entry will be revealed when this seed blooms into a flower. Keep nurturing your growth!")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .italic()
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.cardLight)
                .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(
                colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .overlay {
            if showWateringSuccess {
                WateringSuccessView(
                    seed: seed,
                    streakCount: seed.currentStreakCount,
                    multiplier: seed.wateringStreak?.streakMultiplier ?? 1.0,
                    milestone: seed.checkStreakMilestone()
                ) {
                    showWateringSuccess = false
                }
            }
        }
        .navigationTitle(seed.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit Entry", systemImage: "pencil")
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
            .fullScreenCover(isPresented: $showingFullScreenImage) {
            if let imageData = seed.imageData, let image = imageData.asUIImage {
                FullScreenImageView(image: image)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditSeedView(seed: seed)
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Cancel notifications for this seed
                NotificationManager.shared.cancelNotifications(for: seed)
                
                modelContext.delete(seed)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this journal entry? This action cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        SeedDetailView(seed: JournalSeed(content: "Test content for preview", title: "My Growing Seed"))
    }
    .modelContainer(for: JournalSeed.self, inMemory: true)
}


