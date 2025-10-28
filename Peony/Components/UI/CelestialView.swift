//
//  CelestialView.swift
//  Peony
//
//  Enhanced with smooth crossfade transitions during twilight hours
//

import SwiftUI

/// Time-based view that shows sun during day, moon at night, with twilight crossfades
struct CelestialView: View {
    @Bindable var timeManager = TimeManager.shared
    
    var body: some View {
        ZStack {
            if timeManager.isTwilight {
                // During twilight, show both with crossfade
                if timeManager.timeOfDay == .sunrise {
                    // Sunrise: Moon fading out, Sun fading in
                    MoonView()
                        .opacity(1.0 - timeManager.twilightOpacity)

                    SunView()
                        .opacity(timeManager.twilightOpacity)
                } else {
                    // Sunset: Sun fading out, Moon fading in
                    SunView()
                        .opacity(timeManager.twilightOpacity)

                    MoonView()
                        .opacity(1.0 - timeManager.twilightOpacity)
                }
            } else {
                // Outside twilight, show only one
                if timeManager.isDaytime {
                    SunView()
                } else {
                    MoonView()
                }
            }
        }
    }
}

#Preview("Day") {
    ZStack {
        Color.blue.opacity(0.2)
        CelestialView()
    }
    .ignoresSafeArea()
}

#Preview("Night") {
    ZStack {
        Color.black.opacity(0.8)
        CelestialView()
    }
    .ignoresSafeArea()
}
