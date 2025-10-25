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
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalSeed.self,
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
            Group {
                if hasSeenOnboarding {
                    ContentView()
                        .id("main-content")
                } else {
                    OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                        .id("onboarding")
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: hasSeenOnboarding)
        }
        .modelContainer(sharedModelContainer)
    }
}
