//
//  GardenBedsView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 3 Refactor
//

import SwiftUI
import SwiftData

/// Clean garden beds content without decorative elements
struct GardenBedsView: View {
    let seeds: [JournalSeed]
    
    var numberOfBeds: Int {
        max(1, Int(ceil(Double(seeds.count) / 9.0)))
    }
    
    func seedsForBed(_ bedIndex: Int) -> [JournalSeed] {
        let startIndex = bedIndex * 9
        let endIndex = min(startIndex + 9, seeds.count)
        guard startIndex < seeds.count else { return [] }
        return Array(seeds[startIndex..<endIndex])
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<numberOfBeds, id: \.self) { bedIndex in
                GardenBedView(seeds: seedsForBed(bedIndex), bedIndex: bedIndex)
                
                if bedIndex < numberOfBeds - 1 {
                    GardenPathView()
                        .padding(.vertical, 10)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GardenBedsView(seeds: [])
            .padding()
            .background(Color.ivoryLight)
    }
    .modelContainer(for: JournalSeed.self, inMemory: true)
}




