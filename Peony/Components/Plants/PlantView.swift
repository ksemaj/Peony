//
//  PlantView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 1 Refactor
//

import SwiftUI

/// Wrapper view that displays the appropriate plant visualization based on growth stage
struct PlantView: View {
    let growthStage: GrowthStage
    let size: CGFloat
    
    var body: some View {
        switch growthStage {
        case .seed:
            SeedView(size: size)
        case .sprout:
            SproutView(size: size)
        case .stem:
            StemView(size: size)
        case .bud:
            BudView(size: size)
        case .flower:
            FlowerView(size: size)
        }
    }
}

#Preview("Seed") {
    PlantView(growthStage: .seed, size: 80)
        .padding()
        .background(Color.ivoryLight)
}

#Preview("Sprout") {
    PlantView(growthStage: .sprout, size: 80)
        .padding()
        .background(Color.ivoryLight)
}

#Preview("Stem") {
    PlantView(growthStage: .stem, size: 80)
        .padding()
        .background(Color.ivoryLight)
}

#Preview("Bud") {
    PlantView(growthStage: .bud, size: 80)
        .padding()
        .background(Color.ivoryLight)
}

#Preview("Flower") {
    PlantView(growthStage: .flower, size: 80)
        .padding()
        .background(Color.ivoryLight)
}




