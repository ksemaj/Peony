//
//  FaunaView.swift
//  Peony
//
//  Enhanced with TimeManager integration and lighting awareness
//

import SwiftUI

/// Time-based view that shows butterflies during day, fireflies at night
struct FaunaView: View {
    @State private var timeManager = TimeManager.shared
    
    var body: some View {
        Group {
            if timeManager.isDaytime {
                ButterflyFlockView()
            } else {
                FireflyFieldView()
            }
        }
        .animation(.easeInOut(duration: 2.0), value: timeManager.isDaytime)
    }
}

#Preview("Day") {
    ZStack {
        Color.blue.opacity(0.2)
        FaunaView()
    }
    .ignoresSafeArea()
}

#Preview("Night") {
    ZStack {
        Color.black.opacity(0.8)
        FaunaView()
    }
    .ignoresSafeArea()
}
