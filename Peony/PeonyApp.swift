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
    
    init() {
        // Register default settings (v2.5 AI features)
        AppConfig.AI.registerDefaults()
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
            print("Migration failed, recreating database: \(error)")
            
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
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer even after cleanup: \(error)")
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
