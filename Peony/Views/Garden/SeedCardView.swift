//
//  SeedCardView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI

/// Card view displaying seed summary information
struct SeedCardView: View {
    let seed: JournalSeed
    
    var body: some View {
        VStack(spacing: 12) {
            // Image preview or custom plant
            if let imageData = seed.imageData, let image = imageData.asUIImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green.opacity(0.3), lineWidth: 2))
                }
            } else {
                PlantView(growthStage: seed.growthStage, size: 60)
            }
            
            Text(seed.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 4) {
                ProgressView(value: seed.growthPercentage, total: 100)
                    .tint(.green)
                
                Text("\(Int(seed.growthPercentage))% grown")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            
            Text(seed.plantedDate, style: .date)
                .font(.caption2)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SeedCardView(seed: JournalSeed(content: "Test content", title: "My Seed"))
        .padding()
        .background(Color.ivoryLight)
}


