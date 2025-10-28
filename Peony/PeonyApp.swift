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
    @State private var needsReload = false
    
    init() {
        // Register default settings
        AppSettings.registerDefaults()

        // Initialize location services for accurate sunrise/sunset
        _ = LocationManager.shared

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
    
    var body: some Scene {
        WindowGroup {
            ContentViewWrapper(
                hasSeenOnboarding: $hasSeenOnboarding,
                showDatabaseError: $showDatabaseError
            )
            .animation(.none, value: hasSeenOnboarding)
        }
    }
}

struct ContentViewWrapper: View {
    @Binding var hasSeenOnboarding: Bool
    @Binding var showDatabaseError: Bool
    @StateObject private var databaseManager = DatabaseManager()
    
    var body: some View {
        ZStack {
            if hasSeenOnboarding {
                MainAppView() // v2.0 - Tab navigation (Garden + Journal)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
        .environment(\.modelContainer, databaseManager.container)
        .alert("Database Option", isPresented: $showDatabaseError) {
            Button("Reset Data") {
                databaseManager.resetDatabase()
                // Terminate app to restart with fresh database
                exit(0)
            }
            Button("Close App", role: .cancel) {
                exit(0)
            }
        } message: {
            Text("Unable to load your data. You can reset all data to start fresh, or close the app.")
        }
        .onAppear {
            if databaseManager.hasError {
                showDatabaseError = true
            }
        }
    }
}

@MainActor
class DatabaseManager: ObservableObject {
    var container: ModelContainer
    var hasError: Bool = false
    
    init() {
        var schema = Schema([
            JournalSeed.self,
            WateringStreak.self,
            JournalEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            // Try to create container
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Try recovery
            print("⚠️ Database error, attempting recovery: \(error)")
            
            let storeURL = modelConfiguration.url
            try? FileManager.default.removeItem(at: storeURL)
            try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("wal"))
            try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("shm"))
            
            do {
                container = try ModelContainer(for: schema, configurations: [modelConfiguration])
                print("✅ Database recovered successfully")
            } catch let recoveryError {
                print("❌ CRITICAL: Database recovery failed: \(recoveryError)")
                hasError = true
                // Create a dummy container to prevent crash - it won't work but app won't crash
                do {
                    let dummyConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                    container = try ModelContainer(for: schema, configurations: [dummyConfig])
                } catch let finalError {
                    // This should never happen, but we need a container - log and set error
                    print("❌ FATAL: Could not create any database container: \(finalError)")
                    hasError = true
                    // Create a minimal container to prevent crash
                    container = try! ModelContainer(for: Schema([]), configurations: [])
                }
            }
        }
    }
    
    func resetDatabase() {
        let schema = Schema([
            JournalSeed.self,
            WateringStreak.self,
            JournalEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        let storeURL = modelConfiguration.url
        try? FileManager.default.removeItem(at: storeURL)
        try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("wal"))
        try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("shm"))
    }
}
