//
//  GardenBedView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 3 Refactor
//

import SwiftUI
import SwiftData

/// Individual garden bed containing up to 9 seeds with organic positioning
struct GardenBedView: View {
    let seeds: [JournalSeed]
    let bedIndex: Int
    
    // Natural, organic positions for seeds (up to 9 per bed)
    let organicPositions: [CGPoint] = [
        CGPoint(x: -80, y: -60),   // Top left
        CGPoint(x: 20, y: -70),    // Top center
        CGPoint(x: 100, y: -50),   // Top right
        CGPoint(x: -90, y: 10),    // Middle left
        CGPoint(x: 0, y: 20),      // Center
        CGPoint(x: 95, y: 15),     // Middle right
        CGPoint(x: -70, y: 80),    // Bottom left
        CGPoint(x: 25, y: 90),     // Bottom center
        CGPoint(x: 85, y: 75)      // Bottom right
    ]
    
    var body: some View {
        ZStack {
            // Garden bed border - ONLY border, completely transparent fill
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.green.opacity(0.6), lineWidth: 3)
                .frame(width: 320, height: 320)
                .background(Color.clear)
            
            // Seeds placed organically
            ForEach(Array(seeds.enumerated()), id: \.element.id) { index, seed in
                if index < organicPositions.count {
                    NavigationLink(destination: SeedDetailView(seed: seed)) {
                        PlantedSeedView(seed: seed)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(seed.title), \(Int(seed.growthPercentage)) percent grown")
                    .accessibilityHint("Tap to view details and water")
                    .position(
                        x: 160 + organicPositions[index].x,
                        y: 160 + organicPositions[index].y
                    )
                }
            }
        }
        .frame(width: 320, height: 320)
    }
}

#Preview {
    NavigationStack {
        GardenBedView(seeds: [], bedIndex: 0)
            .padding()
            .background(Color.ivoryLight)
    }
    .modelContainer(for: JournalSeed.self, inMemory: true)
}

