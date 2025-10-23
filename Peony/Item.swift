//
//  Item.swift
//  Peony
//
//  Created by James Kinsey on 10/22/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
