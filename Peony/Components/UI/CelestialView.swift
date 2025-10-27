//
//  CelestialView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Time-based view that shows sun during day, moon at night
struct CelestialView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
    
    var isDaytime: Bool {
        currentHour >= 6 && currentHour < 18 // 6 AM to 6 PM
    }
    
    var body: some View {
        Group {
            if isDaytime {
                SunView()
            } else {
                MoonView()
            }
        }
        .onAppear {
            // Update every minute
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentHour = Calendar.current.component(.hour, from: Date())
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


