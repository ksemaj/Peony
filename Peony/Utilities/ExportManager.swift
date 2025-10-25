//
//  ExportManager.swift
//  Peony
//
//  Created for version 1.1
//

import Foundation
import SwiftData
import UIKit
import PDFKit

@MainActor
class ExportManager {
    static let shared = ExportManager()
    
    private init() {}
    
    // MARK: - JSON Export
    
    struct ExportData: Codable {
        let version: String
        let exportDate: Date
        let seeds: [SeedExportData]
        
        struct SeedExportData: Codable {
            let id: String
            let title: String
            let content: String
            let plantedDate: Date
            let growthPercentage: Double
            let growthStage: String
            let timesWatered: Int
            let growthDurationDays: Int
            let hasImage: Bool
        }
    }
    
    func exportToJSON(seeds: [JournalSeed]) -> Data? {
        let exportSeeds = seeds.map { seed in
            ExportData.SeedExportData(
                id: seed.id.uuidString,
                title: seed.title,
                content: seed.content,
                plantedDate: seed.plantedDate,
                growthPercentage: seed.growthPercentage,
                growthStage: seed.growthStage.displayName,
                timesWatered: seed.timesWatered,
                growthDurationDays: seed.growthDurationDays,
                hasImage: seed.imageData != nil
            )
        }
        
        let exportData = ExportData(
            version: AppConfig.appVersion,
            exportDate: Date(),
            seeds: exportSeeds
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        return try? encoder.encode(exportData)
    }
    
    func saveJSON(seeds: [JournalSeed]) -> URL? {
        guard let data = exportToJSON(seeds: seeds) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let filename = "peony-export-\(dateString).json"
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Error saving JSON: \(error)")
            return nil
        }
    }
    
    // MARK: - PDF Export
    
    func exportToPDF(seeds: [JournalSeed]) -> URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let filename = "peony-journal-\(dateString).pdf"
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        // Create PDF context
        let pdfMetadata = [
            kCGPDFContextCreator: "Peony",
            kCGPDFContextAuthor: "Peony App",
            kCGPDFContextTitle: "Journal Export"
        ]
        
        var mediaBox = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter
        
        guard let pdfContext = CGContext(tempURL as CFURL, mediaBox: &mediaBox, pdfMetadata as CFDictionary) else {
            return nil
        }
        
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - 2 * margin
        
        for (index, seed) in seeds.enumerated() {
            // Start new page
            pdfContext.beginPDFPage(nil)
            
            var yPosition: CGFloat = margin
            
            // Title
            let titleFont = UIFont.boldSystemFont(ofSize: 24)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
            let titleString = seed.title as NSString
            let titleRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: 100)
            titleString.draw(in: titleRect, withAttributes: titleAttributes)
            yPosition += 60
            
            // Date and Growth Info
            let infoFont = UIFont.systemFont(ofSize: 12)
            let infoAttributes: [NSAttributedString.Key: Any] = [
                .font: infoFont,
                .foregroundColor: UIColor.gray
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: seed.plantedDate)
            
            let infoString = "Planted: \(dateString) • Growth: \(Int(seed.growthPercentage))% • Stage: \(seed.growthStage.displayName)" as NSString
            let infoRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: 30)
            infoString.draw(in: infoRect, withAttributes: infoAttributes)
            yPosition += 40
            
            // Content
            let contentFont = UIFont.systemFont(ofSize: 14)
            let contentAttributes: [NSAttributedString.Key: Any] = [
                .font: contentFont,
                .foregroundColor: UIColor.black
            ]
            
            let content = seed.growthPercentage >= 100 ? seed.content : "Entry will be revealed when fully bloomed."
            let contentString = content as NSString
            let contentHeight = pageHeight - yPosition - margin - 100
            let contentRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: contentHeight)
            contentString.draw(in: contentRect, withAttributes: contentAttributes)
            
            // Add image if exists
            if let imageData = seed.imageData, let image = UIImage(data: imageData) {
                let imageYPosition = pageHeight - margin - 200
                let imageRect = CGRect(x: margin, y: imageYPosition, width: 200, height: 200)
                image.draw(in: imageRect)
            }
            
            // Page number
            let pageFont = UIFont.systemFont(ofSize: 10)
            let pageAttributes: [NSAttributedString.Key: Any] = [
                .font: pageFont,
                .foregroundColor: UIColor.lightGray
            ]
            let pageString = "Page \(index + 1) of \(seeds.count)" as NSString
            let pageRect = CGRect(x: margin, y: pageHeight - margin + 10, width: contentWidth, height: 20)
            pageString.draw(in: pageRect, withAttributes: pageAttributes)
            
            pdfContext.endPDFPage()
        }
        
        pdfContext.closePDF()
        
        return tempURL
    }
    
    // MARK: - Share Single Seed
    
    func formatSeedForSharing(seed: JournalSeed) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: seed.plantedDate)
        
        let content = seed.growthPercentage >= 100 ? seed.content : "[Entry will be revealed when fully bloomed]"
        
        return """
        \(seed.title)
        
        Planted: \(dateString)
        Growth: \(Int(seed.growthPercentage))% (\(seed.growthStage.displayName))
        Times Watered: \(seed.timesWatered)
        
        \(content)
        
        —
        Created with Peony 🌸
        """
    }
}

