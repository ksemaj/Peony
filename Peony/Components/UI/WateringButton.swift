//
//  WateringButton.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 4 Refactor
//

import SwiftUI

/// Button for watering seeds with visual feedback
struct WateringButton: View {
    let seed: JournalSeed
    let canWater: Bool
    @Binding var showAnimation: Bool
    let onWater: () -> Void
    
    var waterIconWithSparkles: some View {
        ZStack {
            Image(systemName: "drop.fill")
                .font(.title2)
            
            if showAnimation {
                sparklesView
            }
        }
    }
    
    var sparklesView: some View {
        ForEach(0..<6) { index in
            sparkleItem(at: index)
        }
    }
    
    func sparkleItem(at index: Int) -> some View {
        Image(systemName: "sparkle")
            .font(.caption)
            .foregroundColor(.blue.opacity(0.8))
            .offset(
                x: cos(Double(index) * .pi / 3) * 30,
                y: sin(Double(index) * .pi / 3) * 30
            )
            .opacity(showAnimation ? 1 : 0)
            .scaleEffect(showAnimation ? 1 : 0.1)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(Double(index) * 0.05), value: showAnimation)
    }
    
    var buttonLabel: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(canWater ? "Water Your Seed" : "Already Watered Today")
                    .font(.headline)
                    .foregroundColor(.black)
                
                // Show streak if active
                if seed.currentStreakCount > 0 {
                    HStack(spacing: 2) {
                        Text("🔥")
                            .font(.caption)
                        Text("\(seed.currentStreakCount)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            if canWater {
                let multiplier = seed.wateringStreak?.streakMultiplier ?? 1.0
                Text("Tap to give +\(String(format: "%.1f", multiplier))% growth")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            } else {
                Text("Come back tomorrow!")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
        }
    }
    
    var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(canWater ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(canWater ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 2)
            )
    }
    
    var buttonContent: some View {
        HStack(spacing: 12) {
            waterIconWithSparkles
            buttonLabel
            Spacer()
            
            if canWater {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            }
        }
        .padding()
        .background(buttonBackground)
    }
    
    var body: some View {
        Button {
            if canWater {
                onWater()
            }
        } label: {
            buttonContent
        }
        .buttonStyle(.plain)
        .disabled(!canWater)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        WateringButton(
            seed: JournalSeed(content: "Test", title: "Test Seed"),
            canWater: true,
            showAnimation: .constant(false),
            onWater: {}
        )
        
        WateringButton(
            seed: JournalSeed(content: "Test", title: "Test Seed"),
            canWater: false,
            showAnimation: .constant(false),
            onWater: {}
        )
    }
    .padding()
    .background(Color.ivoryLight)
}


