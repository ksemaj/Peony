//
//  ExportDataView.swift
//  Peony
//
//  Created for version 2.6+ - Data Export Feature
//

import SwiftUI
import SwiftData

struct ExportDataView: View {
    let seeds: [JournalSeed]
    let entries: [JournalEntry]
    let streaks: [WateringStreak]
    
    @Environment(\.dismiss) private var dismiss
    @State private var isExporting = false
    @State private var exportError: String?
    @State private var showShareSheet = false
    @State private var exportURL: URL?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                        .symbolVariant(.fill)
                    
                    Text("Export Your Data")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    
                    Text("Your data will be exported as a JSON file you can save anywhere")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Data summary
                VStack(alignment: .leading, spacing: 12) {
                    DataSummaryRow(icon: "🌱", label: "Seeds", count: seeds.count)
                    DataSummaryRow(icon: "📔", label: "Journal Entries", count: entries.count)
                    DataSummaryRow(icon: "🔥", label: "Watering Streaks", count: streaks.count)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .padding(.horizontal)
                
                if let error = exportError {
                    Text("Error: \(error)")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                // Export button
                Button {
                    exportData()
                } label: {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Exporting...")
                        } else {
                            Text("Export All Data")
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isExporting ? Color.gray : Color.green)
                    .cornerRadius(12)
                }
                .disabled(isExporting)
                .padding(.horizontal)
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .background(
                LinearGradient(
                    colors: [Color.ivoryLight, Color.pastelGreenLight],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showShareSheet) {
                if let url = exportURL {
                    ShareSheet(items: [url])
                        .onDisappear {
                            // Auto-dismiss export view after share sheet closes
                            dismiss()
                        }
                }
            }
        }
    }
    
    private func exportData() {
        isExporting = true
        exportError = nil
        
        DataExporter.exportAllData(
            seeds: seeds,
            entries: entries,
            streaks: streaks
        ) { result in
            isExporting = false
            
            switch result {
            case .success(let url):
                exportURL = url
                showShareSheet = true
                // Don't dismiss - let user interact with share sheet
            case .failure(let error):
                exportError = error.localizedDescription
            }
        }
    }
}

struct DataSummaryRow: View {
    let icon: String
    let label: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title3)
            Text(label)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Text("\(count)")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.0, green: 0.5, blue: 0.0))
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

