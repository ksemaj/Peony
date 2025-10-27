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
    @State private var previousTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Garden Tab with animated wrapper
            AnimatedTabContent(
                selectedTab: selectedTab,
                previousTab: previousTab,
                currentTag: 0
            ) {
                ContentView()
            }
            .tabItem {
                Label("Garden", systemImage: "leaf.fill")
            }
            .tag(0)
            
            // Journal Tab with animated wrapper (renamed from Notes in v2.6)
            AnimatedTabContent(
                selectedTab: selectedTab,
                previousTab: previousTab,
                currentTag: 1
            ) {
                NotesView()
            }
            .tabItem {
                Label("Journal", systemImage: "book.fill")
            }
            .tag(1)
        }
        .tint(.green)
        .onChange(of: selectedTab) { oldValue, newValue in
            previousTab = oldValue
        }
    }
}

// MARK: - Animated Tab Content Wrapper

struct AnimatedTabContent<Content: View>: View {
    let selectedTab: Int
    let previousTab: Int
    let currentTag: Int
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .transition(.asymmetric(
                insertion: slideInsertion,
                removal: slideRemoval
            ))
            .id("\(currentTag)-\(selectedTab)")
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: selectedTab)
    }
    
    private var slideInsertion: AnyTransition {
        let isMovingForward = selectedTab > previousTab
        return .move(edge: isMovingForward ? .trailing : .leading)
            .combined(with: .opacity)
    }
    
    private var slideRemoval: AnyTransition {
        let isMovingForward = selectedTab > previousTab
        return .move(edge: isMovingForward ? .leading : .trailing)
            .combined(with: .opacity)
    }
}

#Preview {
    MainAppView()
        .modelContainer(for: JournalSeed.self, inMemory: true)
}

