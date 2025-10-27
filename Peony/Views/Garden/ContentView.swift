//
//  ContentView.swift
//  Peony
//
//  Refactored - Phase 7: All components extracted to organized files
//
//  Component Organization:
//  - Components/Plants/ - Plant growth visualizations (Seed, Sprout, Stem, Bud, Flower, PlantView)
//  - Components/Flora/ - Decorative elements (Tree, Bush, Wildflower, Mushroom, Rock, GrassBlade, DirtMound)
//  - Components/UI/ - Backgrounds, effects, buttons (Sky, Garden, Celestial, Fauna, Watering, etc.)
//  - Views/Garden/ - Seed management (GardenBed, GardenLayout, PlantSeed, EditSeed, SeedDetail, etc.)
//  - Views/Shared/ - Utilities (FullScreenImage)
//

import SwiftUI
import SwiftData
import PhotosUI

// MARK: - Main Garden View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalSeed.plantedDate, order: .reverse) private var allSeeds: [JournalSeed]
    @State private var showingPlantSheet = false
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fixed garden background with sky and celestial elements
                GardenBackgroundView()
                
                // Scrollable content layer
                if allSeeds.isEmpty {
                    emptyGardenView
                } else {
                    GardenLayoutView(seeds: allSeeds)
                }
            }
            .navigationTitle("My Garden")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    GardenToolbarButtons(
                        showingOnboarding: $showingOnboarding
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        NotificationTestButton()
                        
                        Button {
                            showingPlantSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingPlantSheet) {
                PlantSeedView()
            }
            .sheet(isPresented: $showingOnboarding) {
                OnboardingTutorialView(isPresented: $showingOnboarding)
            }
        }
    }
    
    // MARK: - Empty Garden State
    
    private var emptyGardenView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Large seed icon
            SeedView(size: 80)
            
            // Welcome message
            Text("Your Garden Awaits")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("Plant your first seed to begin your mindful journaling journey")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // Plant button
            Button {
                showingPlantSheet = true
            } label: {
                Text("Plant Your First Seed")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.warmGold, Color.amberGlow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .warmGold.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            .padding(.top, 8)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}

