//
//  DataExporter.swift
//  Peony
//
//  Created for version 2.6+ - Data Export Feature
//

import Foundation
import SwiftData

/// Utility for exporting app data to JSON
final class DataExporter {
    
    /// Export all app data to a JSON file
    static func exportAllData(
        seeds: [JournalSeed],
        entries: [JournalEntry],
        streaks: [WateringStreak],
        completion: @escaping @Sendable (Result<URL, Error>) -> Void
    ) {
        Task { @MainActor in
            do {
                // Extract data first to avoid capturing SwiftData models in async context
                let exportSeeds = seeds.map { $0.asExportable }
                let exportEntries = entries.map { $0.asExportable }
                let exportStreaks = streaks.map { $0.asExportable }
                
                // Create export data structure
                let exportData = ExportData(
                    version: AppConfig.appVersion,
                    exportDate: Date(),
                    seeds: exportSeeds,
                    entries: exportEntries,
                    streaks: exportStreaks
                )
                
                // Encode to JSON (must happen on MainActor due to ExportData conformance)
                let jsonData = try await MainActor.run {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                    encoder.dateEncodingStrategy = .iso8601
                    return try encoder.encode(exportData)
                }
                
                // Create temporary file
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("peony_export_\(Date().timeIntervalSince1970).json")
                
                try jsonData.write(to: tempURL)
                
                DispatchQueue.main.async {
                    completion(.success(tempURL))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - Export Data Structure

struct ExportData: Codable {
    let version: String
    let exportDate: Date
    let seeds: [ExportableSeed]
    let entries: [ExportableEntry]
    let streaks: [ExportableStreak]
}

struct ExportableSeed: Codable {
    let id: String
    let title: String
    let content: String
    let plantedDate: Date
    let lastWateredDate: Date
    let growthPercentage: Double
    let timesWatered: Int
    let growthDurationDays: Int
    let hasImage: Bool
}

struct ExportableEntry: Codable {
    let id: String
    let content: String
    let createdAt: Date
    let wordCount: Int
    let preview: String
    let detectedMood: String?
}

struct ExportableStreak: Codable {
    let seedId: String
    let currentStreak: Int
    let longestStreak: Int
    let lastWateredDate: Date
}

// MARK: - Model Extensions for Export

extension JournalSeed {
    var asExportable: ExportableSeed {
        ExportableSeed(
            id: id.uuidString,
            title: title,
            content: content,
            plantedDate: plantedDate,
            lastWateredDate: lastWateredDate,
            growthPercentage: growthPercentage,
            timesWatered: timesWatered,
            growthDurationDays: growthDurationDays,
            hasImage: imageData != nil
        )
    }
}

extension JournalEntry {
    var asExportable: ExportableEntry {
        ExportableEntry(
            id: id.uuidString,
            content: content,
            createdAt: createdDate,
            wordCount: wordCount,
            preview: preview,
            detectedMood: detectedMood
        )
    }
}

extension WateringStreak {
    var asExportable: ExportableStreak {
        ExportableStreak(
            seedId: seedId.uuidString,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastWateredDate: lastWateredDate
        )
    }
}

