//
//  PlantedSeedView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 3 Refactor
//

import SwiftUI

/// Visual representation of a planted seed in the garden
struct PlantedSeedView: View {
    let seed: JournalSeed
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Dirt mound
                DirtMoundView(size: 50)
                
                // Plant growing from soil
                if let image = seed.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(radius: 5)
                } else {
                    PlantView(growthStage: seed.growthStage, size: 50)
                }
            }
            
            // Seed name tag
            Text(seed.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.8))
                        .shadow(radius: 2)
                )
                .lineLimit(1)
        }
        .frame(width: 100)
    }
}

#Preview {
    PlantedSeedView(seed: JournalSeed(content: "Test seed", title: "My Seed"))
        .padding()
        .background(Color.pastelGreenLight)
}


