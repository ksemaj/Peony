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
        .onAppear {
            // Aggressively remove ALL tab bar backgrounds
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().barTintColor = .clear
            UITabBar.appearance().backgroundColor = .clear
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage()
            
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.backgroundEffect = nil // Remove blur effect
            
            // Make tab items visible
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.selected.iconColor = .systemGreen
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
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

