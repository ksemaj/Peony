//
//  GrowthStage.swift
//  Peony
//
//  Created for version 1.1
//

import Foundation

enum GrowthStage: String {
    case seed = "🌱"
    case sprout = "🌿"
    case stem = "🪴"
    case bud = "🌺"
    case flower = "🌸"
    
    var displayName: String {
        switch self {
        case .seed: return "Seed"
        case .sprout: return "Sprout"
        case .stem: return "Growing"
        case .bud: return "Budding"
        case .flower: return "Full Bloom"
        }
    }
}

