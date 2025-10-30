//
//  AmbientLighting.swift
//  Peony
//
//  Dynamic lighting system for time-based garden atmosphere
//

import SwiftUI
import Foundation

/// Lighting condition that affects garden appearance
struct LightingCondition {
    let brightness: Double        // 0.0 = dark, 1.0 = bright
    let tintColor: Color         // Color tint for atmosphere
    let shadowIntensity: Double  // Shadow depth (0.0 = no shadows, 1.0 = deep)
    let warmth: Double           // Warmth of light (0.0 = cool, 1.0 = warm)
}

/// Ambient lighting calculator and manager
class AmbientLighting {
    /// Shared singleton instance
    static let shared = AmbientLighting()
    
    private init() {}
    
    /// Calculate current lighting conditions based on time and season
    func getCurrentLighting(timeManager: TimeManager = .shared) -> LightingCondition {
        let timeOfDay = timeManager.timeOfDay
        let season = timeManager.currentSeason
        
        // Base lighting on time of day - 3 day + 3 night stages
        switch timeOfDay {
        case .sunrise:
            return LightingCondition(
                brightness: 0.6,
                tintColor: getSeasonalDawnTint(season: season).opacity(0.25),
                shadowIntensity: 0.4,
                warmth: 0.7
            )

        case .day:
            return LightingCondition(
                brightness: 0.95,
                tintColor: Color.clear,
                shadowIntensity: 0.15,
                warmth: 0.6
            )

        case .afternoon:
            return LightingCondition(
                brightness: 1.0,
                tintColor: Color.clear,
                shadowIntensity: 0.1,
                warmth: 0.5
            )

        case .sunset:
            return LightingCondition(
                brightness: 0.55,
                tintColor: getSeasonalDuskTint(season: season).opacity(0.3),
                shadowIntensity: 0.5,
                warmth: 0.8
            )

        case .evening:
            return LightingCondition(
                brightness: 0.4,
                tintColor: Color(red: 0.65, green: 0.70, blue: 0.85).opacity(0.35),
                shadowIntensity: 0.65,
                warmth: 0.2
            )

        case .midnight:
            return LightingCondition(
                brightness: 0.25,
                tintColor: Color(red: 0.65, green: 0.70, blue: 0.85).opacity(0.4),
                shadowIntensity: 0.8,
                warmth: 0.1
            )
        }
    }
    
    /// Get seasonal dawn tint color
    private func getSeasonalDawnTint(season: Season) -> Color {
        switch season {
        case .spring:
            return Color(red: 0.98, green: 0.85, blue: 0.88) // Soft pink
        case .summer:
            return Color(red: 1.0, green: 0.88, blue: 0.70) // Golden
        case .fall:
            return Color(red: 1.0, green: 0.80, blue: 0.65) // Orange-gold
        case .winter:
            return Color(red: 0.92, green: 0.90, blue: 0.95) // Cool lavender
        }
    }
    
    /// Get seasonal dusk tint color
    private func getSeasonalDuskTint(season: Season) -> Color {
        switch season {
        case .spring:
            return Color(red: 0.95, green: 0.85, blue: 0.90) // Rose pink
        case .summer:
            return Color(red: 1.0, green: 0.75, blue: 0.60) // Warm orange
        case .fall:
            return Color(red: 0.98, green: 0.70, blue: 0.55) // Deep orange
        case .winter:
            return Color(red: 0.88, green: 0.85, blue: 0.92) // Cool purple
        }
    }
    
    /// Get lighting modifier for fauna (butterflies/fireflies)
    func getFaunaLightingModifier(timeManager: TimeManager = .shared) -> (opacity: Double, glow: Double) {
        let lighting = getCurrentLighting(timeManager: timeManager)
        
        // Butterflies: more visible in bright light
        // Fireflies: glow more in darkness
        if timeManager.isDaytime {
            return (
                opacity: lighting.brightness,
                glow: 0.3
            )
        } else {
            return (
                opacity: 0.8,
                glow: 1.0 - lighting.brightness
            )
        }
    }
}




