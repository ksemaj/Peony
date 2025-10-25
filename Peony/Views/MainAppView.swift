//
//  MainAppView.swift
//  Peony
//
//  Created for version 2.0
//

import SwiftUI
import SwiftData

struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Garden Tab (existing seed planting & watering)
            ContentView()
                .tabItem {
                    Label("Garden", systemImage: "leaf.fill")
                }
                .tag(0)
            
            // Notes Tab (NEW - quick daily journaling)
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(1)
        }
        .tint(.green) // Green accent for tabs
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedTab)
    }
}

#Preview {
    MainAppView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}

