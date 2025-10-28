//
//  ColorExtensions.swift
//  Peony
//
//  Created for version 1.1
//  Updated v3.0 - Deep Forest Dark Theme
//

import SwiftUI

// MARK: - Custom Design System Colors
extension Color {
    // MARK: - Dark Forest Theme Backgrounds
    static let forestNight = Color(red: 0.08, green: 0.12, blue: 0.10)        // #141F1A
    static let forestDark = Color(red: 0.11, green: 0.18, blue: 0.14)         // #1C2E24
    static let forestMid = Color(red: 0.18, green: 0.29, blue: 0.24)          // #2D4A3E
    static let forestDeep = Color(red: 0.11, green: 0.23, blue: 0.18)         // #1C3A2E

    // MARK: - Accent Colors
    static let warmGold = Color(red: 0.83, green: 0.65, blue: 0.46)           // #D4A574
    static let amberGlow = Color(red: 0.85, green: 0.71, blue: 0.42)          // #D9B56B
    static let moonlightIvory = Color(red: 0.96, green: 0.95, blue: 0.91)     // #F5F1E8

    // MARK: - Text Colors
    static let creamText = Color(red: 0.96, green: 0.95, blue: 0.91)          // #F5F1E8
    static let softGray = Color(red: 0.63, green: 0.63, blue: 0.63)           // #A0A0A0
    static let dimGray = Color(red: 0.47, green: 0.47, blue: 0.47)            // #787878

    // MARK: - UI Element Colors
    static let cardDark = Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.85)  // Dark card background
    static let cardLight = Color(red: 0.96, green: 0.95, blue: 0.91).opacity(0.95) // Light card on dark
    static let glassOverlay = Color.white.opacity(0.08)                       // Glass morphism effect

    // MARK: - Enhanced Plant Colors (Vivid for dark background)
    static let seedBrown = Color(red: 0.50, green: 0.36, blue: 0.28)
    static let sproutGreen = Color(red: 0.45, green: 0.75, blue: 0.40)        // More vivid
    static let stemGreen = Color(red: 0.38, green: 0.68, blue: 0.35)          // Brighter
    static let budPink = Color(red: 0.76, green: 0.26, blue: 0.42)            // Jewel tone #C1426A
    static let flowerPink = Color(red: 0.95, green: 0.65, blue: 0.75)         // Softer vivid pink
    static let flowerCenter = Color(red: 0.95, green: 0.85, blue: 0.45)       // Golden center

    // MARK: - Tree Colors (Enhanced for dark theme)
    static let treeLeafDark = Color(red: 0.25, green: 0.45, blue: 0.28)       // Darker forest green
    static let treeLeafMid = Color(red: 0.35, green: 0.58, blue: 0.38)        // Rich mid green
    static let treeLeafLight = Color(red: 0.48, green: 0.72, blue: 0.45)      // Vibrant light green
    static let treeTrunkDark = Color(red: 0.24, green: 0.16, blue: 0.09)      // Deep brown
    static let treeTrunkLight = Color(red: 0.42, green: 0.30, blue: 0.20)     // Warm brown

    // MARK: - Dirt Colors (Warmer, richer)
    static let dirtDark = Color(red: 0.24, green: 0.16, blue: 0.09)           // #3D2817
    static let dirtLight = Color(red: 0.42, green: 0.30, blue: 0.20)          // Amber undertone

    // MARK: - Legacy Colors (keeping for compatibility)
    static let pastelGreenLight = Color(red: 0.88, green: 0.95, blue: 0.88)
    static let pastelGreenMid = Color(red: 0.85, green: 0.93, blue: 0.85)
    static let ivoryLight = Color(red: 1.0, green: 1.0, blue: 0.94)
    static let ivoryMid = Color(red: 0.98, green: 0.98, blue: 0.90)
}

// MARK: - Typography Extension
extension Font {
    // Serif fonts for headlines (Playfair Display Variable Font with fallback)
    // Supports Dynamic Type scaling
    static func serifDisplay(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Try custom font first, fall back to system serif
        if UIFont(name: "PlayfairDisplay-Regular", size: size) != nil {
            return .custom("Playfair Display", size: size).weight(weight)
        }
        // Fallback to Georgia (system serif)
        return .custom("Georgia", size: size).weight(weight)
    }

    static func serifDisplayBold(_ size: CGFloat) -> Font {
        // Try custom font first, fall back to system serif
        if UIFont(name: "PlayfairDisplay-Bold", size: size) != nil {
            return .custom("Playfair Display", size: size).weight(.bold)
        }
        // Fallback to Georgia Bold
        return .custom("Georgia-Bold", size: size)
    }

    // Dynamic Type friendly convenience methods
    // These will scale automatically with user's accessibility settings
    static var serifTitle: Font {
        serifDisplayBold(36)
    }
    static var serifLargeTitle: Font {
        serifDisplayBold(42)
    }
    static var serifHeadline: Font {
        serifDisplayBold(24)
    }
    static var serifSubheadline: Font {
        serifDisplay(20, weight: .semibold)
    }
}

