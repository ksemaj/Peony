//
//  SettingsView.swift
//  Peony
//
//  Created for version 1.1
//

import SwiftUI
import UserNotifications
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allSeeds: [JournalSeed]
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showingShareSheet = false
    @State private var shareURL: URL?
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("wateringRemindersEnabled") private var wateringRemindersEnabled = true
    @AppStorage("milestoneNotificationsEnabled") private var milestoneNotificationsEnabled = true
    @AppStorage("weeklyCheckinEnabled") private var weeklyCheckinEnabled = true
    @AppStorage("defaultGrowthDays") private var defaultGrowthDays = 90
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Garden background
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight, Color.ivoryMid],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    // Notifications Section
                    Section {
                        if !notificationManager.isAuthorized {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notifications Disabled")
                                    .font(.headline)
                                Text("Enable notifications in Settings to receive growth updates and reminders.")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                
                                Button("Open Settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .foregroundColor(.green)
                                .padding(.top, 4)
                            }
                            .padding(.vertical, 4)
                        } else {
                            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                            
                            if notificationsEnabled {
                                Toggle("Watering Reminders", isOn: $wateringRemindersEnabled)
                                    .disabled(!notificationsEnabled)
                                
                                Toggle("Growth Milestones", isOn: $milestoneNotificationsEnabled)
                                    .disabled(!notificationsEnabled)
                                
                                Toggle("Weekly Check-in", isOn: $weeklyCheckinEnabled)
                                    .disabled(!notificationsEnabled)
                                    .onChange(of: weeklyCheckinEnabled) { oldValue, newValue in
                                        if newValue {
                                            notificationManager.scheduleWeeklyCheckin()
                                        } else {
                                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weekly-checkin"])
                                        }
                                    }
                            }
                        }
                    } header: {
                        Text("Notifications")
                    } footer: {
                        if notificationManager.isAuthorized {
                            Text("Receive reminders to water your seeds and celebrate growth milestones.")
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    
                    // Growth Settings Section
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Default Growth Duration: \(defaultGrowthDays) days")
                                .font(.subheadline)
                            
                            Slider(value: Binding(
                                get: { Double(defaultGrowthDays) },
                                set: { defaultGrowthDays = Int($0) }
                            ), in: 30...365, step: 15)
                            
                            HStack {
                                Text("30 days")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                Spacer()
                                Text("365 days")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Growth Settings")
                    } footer: {
                        Text("New seeds will take this many days to fully bloom (without watering bonuses).")
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    
                    // Export Section
                    Section {
                        Button {
                            exportJSON()
                        } label: {
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.green)
                                Text("Export as JSON")
                                    .foregroundColor(.black)
                            }
                        }
                        .disabled(allSeeds.isEmpty)
                        
                        Button {
                            exportPDF()
                        } label: {
                            HStack {
                                Image(systemName: "doc.richtext")
                                    .foregroundColor(.green)
                                Text("Export as PDF")
                                    .foregroundColor(.black)
                            }
                        }
                        .disabled(allSeeds.isEmpty)
                    } header: {
                        Text("Data Export")
                    } footer: {
                        if allSeeds.isEmpty {
                            Text("Plant some seeds to enable export.")
                        } else {
                            Text("Export your journal entries to JSON or PDF format.")
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    
                    // About Section
                    Section {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.1.0")
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        
                        Link(destination: URL(string: "https://example.com/privacy")!) {
                            HStack {
                                Text("Privacy Policy")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            }
                        }
                        
                        Link(destination: URL(string: "https://example.com/support")!) {
                            HStack {
                                Text("Support")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.caption)
                                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                            }
                        }
                    } header: {
                        Text("About")
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = shareURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }
    
    // MARK: - Export Functions
    
    private func exportJSON() {
        if let url = ExportManager.shared.saveJSON(seeds: allSeeds) {
            shareURL = url
            showingShareSheet = true
        }
    }
    
    private func exportPDF() {
        if let url = ExportManager.shared.exportToPDF(seeds: allSeeds) {
            shareURL = url
            showingShareSheet = true
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
}

