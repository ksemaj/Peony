//
//  GardenLayoutView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 3 Refactor
//

import SwiftUI
import SwiftData

/// Full garden view with beds and decorative flora elements
struct GardenLayoutView: View {
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
        GeometryReader { geometry in
            VStack(spacing: 20) {
                // Add spacer to push content down more - use stable calculation
                // Default to 200 if geometry is not yet available to prevent shifts
                let spacerHeight = geometry.size.height > 0 
                    ? max(80, (geometry.size.height - 300) / 2)
                    : 200
                Spacer()
                    .frame(height: spacerHeight)
                
                ForEach(0..<numberOfBeds, id: \.self) { bedIndex in
                    GardenBedView(seeds: seedsForBed(bedIndex), bedIndex: bedIndex)
                    
                    if bedIndex < numberOfBeds - 1 {
                        GardenPathView()
                            .padding(.vertical, 10)
                    }
                }
                
                // Bottom padding
                Spacer()
                    .frame(height: 40)
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true) // Prevent initial shifting
        }
    }
}

#Preview {
    NavigationStack {
        GardenLayoutView(seeds: [])
    }
    .modelContainer(for: JournalSeed.self, inMemory: true)
}

