//
//  SkyBackgroundView.swift
//  Peony
//
//  Enhanced with seasonal variations and 6-period gradient system
//

import SwiftUI

/// Time-based sky background that changes color throughout the day with seasonal variations
struct SkyBackgroundView: View {
    @State private var timeManager = TimeManager.shared
    
    /// Get sky colors based on current time of day and season
    var skyColors: [Color] {
        let season = timeManager.currentSeason
        let timeOfDay = timeManager.timeOfDay
        
        // Get the appropriate color palette tuple
        let palette: [(r: Double, g: Double, b: Double)]
        
        switch (season, timeOfDay) {
        // Spring palettes
        case (.spring, .preDawn):
            palette = AppConfig.Environment.SeasonalPalettes.springPreDawn
        case (.spring, .dawn):
            palette = AppConfig.Environment.SeasonalPalettes.springDawn
        case (.spring, .morning), (.spring, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.springDay
        case (.spring, .dusk):
            palette = AppConfig.Environment.SeasonalPalettes.springDusk
        case (.spring, .night):
            palette = AppConfig.Environment.SeasonalPalettes.springNight
            
        // Summer palettes
        case (.summer, .preDawn):
            palette = AppConfig.Environment.SeasonalPalettes.summerPreDawn
        case (.summer, .dawn):
            palette = AppConfig.Environment.SeasonalPalettes.summerDawn
        case (.summer, .morning), (.summer, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.summerDay
        case (.summer, .dusk):
            palette = AppConfig.Environment.SeasonalPalettes.summerDusk
        case (.summer, .night):
            palette = AppConfig.Environment.SeasonalPalettes.summerNight
            
        // Fall palettes
        case (.fall, .preDawn):
            palette = AppConfig.Environment.SeasonalPalettes.fallPreDawn
        case (.fall, .dawn):
            palette = AppConfig.Environment.SeasonalPalettes.fallDawn
        case (.fall, .morning), (.fall, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.fallDay
        case (.fall, .dusk):
            palette = AppConfig.Environment.SeasonalPalettes.fallDusk
        case (.fall, .night):
            palette = AppConfig.Environment.SeasonalPalettes.fallNight
            
        // Winter palettes
        case (.winter, .preDawn):
            palette = AppConfig.Environment.SeasonalPalettes.winterPreDawn
        case (.winter, .dawn):
            palette = AppConfig.Environment.SeasonalPalettes.winterDawn
        case (.winter, .morning), (.winter, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.winterDay
        case (.winter, .dusk):
            palette = AppConfig.Environment.SeasonalPalettes.winterDusk
        case (.winter, .night):
            palette = AppConfig.Environment.SeasonalPalettes.winterNight
        }
        
        // Convert tuples to Color objects
        return palette.map { Color(red: $0.r, green: $0.g, blue: $0.b) }
    }
    
    var body: some View {
        LinearGradient(
            colors: skyColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 2.0), value: timeManager.timeOfDay)
        .animation(.easeInOut(duration: 5.0), value: timeManager.currentSeason)
    }
}

#Preview("Spring Day") {
    SkyBackgroundView()
}

#Preview("Summer Dusk") {
    SkyBackgroundView()
}

#Preview("Fall Dawn") {
    SkyBackgroundView()
}

#Preview("Winter Night") {
    SkyBackgroundView()
}
