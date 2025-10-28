//
//  PeonyApp.swift
//  Peony
//
//  Created by James Kinsey on 10/22/25.
//

import SwiftUI
import SwiftData

@main
struct PeonyApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showDatabaseError = false
    @State private var databaseErrorMessage = ""
    
    init() {
        // Register default settings
        AppSettings.registerDefaults()
        
        // COMPLETELY remove tab bar background - AGGRESSIVE MODE
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.backgroundEffect = nil // CRITICAL: Remove blur/vibrancy effect
        
        // Make all tab bar items transparent too
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .systemGreen
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        
        appearance.inlineLayoutAppearance.normal.iconColor = .white
        appearance.inlineLayoutAppearance.selected.iconColor = .systemGreen
        appearance.compactInlineLayoutAppearance.normal.iconColor = .white
        appearance.compactInlineLayoutAppearance.selected.iconColor = .systemGreen
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .clear
        UITabBar.appearance().backgroundColor = .clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        // Make navigation bars completely transparent
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        navAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().isTranslucent = true
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalSeed.self,
            WateringStreak.self,
            JournalEntry.self, // v2.0 - Journal feature (renamed from QuickNote in v2.6)
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Migration failed - delete the old store and create a fresh one
            print("⚠️ Database migration failed, attempting recovery: \(error)")
            
            // Get the default store URL and delete the old store files
            let storeURL = modelConfiguration.url
            try? FileManager.default.removeItem(at: storeURL)
            
            // Also remove related files
            let walURL = storeURL.appendingPathExtension("wal")
            let shmURL = storeURL.appendingPathExtension("shm")
            try? FileManager.default.removeItem(at: walURL)
            try? FileManager.default.removeItem(at: shmURL)
            
            // Try creating the container again
            do {
                print("✅ Database recreated successfully")
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                // Last resort: create in-memory container so app doesn't crash
                print("❌ CRITICAL: Could not create persistent database. Using in-memory storage.")
                print("❌ Error: \(error)")
                
                let inMemoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                do {
                    return try ModelContainer(for: schema, configurations: [inMemoryConfig])
                } catch {
                    // This should never fail, but if it does, we have no choice
                    print("❌ FATAL: Even in-memory database failed: \(error)")
                    fatalError("Critical database error: \(error)")
                }
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasSeenOnboarding {
                    MainAppView() // v2.0 - Tab navigation (Garden + Journal)
                        .transition(.opacity)
                } else {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
        }
        .modelContainer(sharedModelContainer)
    }
}
