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
            // Garden bed background - Pastel green
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.pastelGreenLight,
                            Color.pastelGreenMid
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.3), lineWidth: 3)
                )
                .frame(width: 340, height: 260)
            
            // Seeds placed organically
            ForEach(Array(seeds.enumerated()), id: \.element.id) { index, seed in
                if index < organicPositions.count {
                    NavigationLink(destination: SeedDetailView(seed: seed)) {
                        PlantedSeedView(seed: seed)
                    }
                    .buttonStyle(.plain)
                    .position(
                        x: 170 + organicPositions[index].x,
                        y: 130 + organicPositions[index].y
                    )
                }
            }
        }
        .frame(width: 340, height: 260)
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

