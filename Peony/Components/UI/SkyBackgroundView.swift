//
//  SkyBackgroundView.swift
//  Peony
//
//  Enhanced with seasonal variations and 6-period gradient system
//

import SwiftUI

/// Time-based sky background that changes color throughout the day with seasonal variations
struct SkyBackgroundView: View {
    @Bindable var timeManager = TimeManager.shared
    
    /// Get sky colors based on current time of day and season
    var skyColors: [Color] {
        let season = timeManager.currentSeason
        let timeOfDay = timeManager.timeOfDay

        // Get the appropriate color palette tuple
        let palette: [(r: Double, g: Double, b: Double)]
        
        switch (season, timeOfDay) {
        // Spring palettes - 3 day + 3 night
        case (.spring, .sunrise):
            palette = AppConfig.Environment.SeasonalPalettes.springSunrise
        case (.spring, .day):
            palette = AppConfig.Environment.SeasonalPalettes.springDay
        case (.spring, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.springAfternoon
        case (.spring, .sunset):
            palette = AppConfig.Environment.SeasonalPalettes.springSunset
        case (.spring, .evening):
            palette = AppConfig.Environment.SeasonalPalettes.springEvening
        case (.spring, .midnight):
            palette = AppConfig.Environment.SeasonalPalettes.springMidnight

        // Summer palettes - 3 day + 3 night
        case (.summer, .sunrise):
            palette = AppConfig.Environment.SeasonalPalettes.summerSunrise
        case (.summer, .day):
            palette = AppConfig.Environment.SeasonalPalettes.summerDay
        case (.summer, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.summerAfternoon
        case (.summer, .sunset):
            palette = AppConfig.Environment.SeasonalPalettes.summerSunset
        case (.summer, .evening):
            palette = AppConfig.Environment.SeasonalPalettes.summerEvening
        case (.summer, .midnight):
            palette = AppConfig.Environment.SeasonalPalettes.summerMidnight

        // Fall palettes - 3 day + 3 night
        case (.fall, .sunrise):
            palette = AppConfig.Environment.SeasonalPalettes.fallSunrise
        case (.fall, .day):
            palette = AppConfig.Environment.SeasonalPalettes.fallDay
        case (.fall, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.fallAfternoon
        case (.fall, .sunset):
            palette = AppConfig.Environment.SeasonalPalettes.fallSunset
        case (.fall, .evening):
            palette = AppConfig.Environment.SeasonalPalettes.fallEvening
        case (.fall, .midnight):
            palette = AppConfig.Environment.SeasonalPalettes.fallMidnight

        // Winter palettes - 3 day + 3 night
        case (.winter, .sunrise):
            palette = AppConfig.Environment.SeasonalPalettes.winterSunrise
        case (.winter, .day):
            palette = AppConfig.Environment.SeasonalPalettes.winterDay
        case (.winter, .afternoon):
            palette = AppConfig.Environment.SeasonalPalettes.winterAfternoon
        case (.winter, .sunset):
            palette = AppConfig.Environment.SeasonalPalettes.winterSunset
        case (.winter, .evening):
            palette = AppConfig.Environment.SeasonalPalettes.winterEvening
        case (.winter, .midnight):
            palette = AppConfig.Environment.SeasonalPalettes.winterMidnight
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
