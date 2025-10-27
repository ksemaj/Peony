//
//  FaunaView.swift
//  Peony
//
//  Extracted from ContentView.swift - Phase 2 Refactor
//

import SwiftUI

/// Time-based view that shows butterflies during day, fireflies at night
struct FaunaView: View {
    @State private var currentHour: Int = Calendar.current.component(.hour, from: Date())
    
    var isDaytime: Bool {
        currentHour >= 6 && currentHour < 18
    }
    
    var body: some View {
        Group {
            if isDaytime {
                ButterflyFlockView()
            } else {
                FireflyFieldView()
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                currentHour = Calendar.current.component(.hour, from: Date())
            }
        }
    }
}

#Preview("Day") {
    ZStack {
        Color.blue.opacity(0.2)
        FaunaView()
    }
    .ignoresSafeArea()
}


