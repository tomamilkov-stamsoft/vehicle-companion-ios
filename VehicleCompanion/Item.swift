//
//  Item.swift
//  VehicleCompanion
//
//  Created by Toma Milkov on 9.02.26.
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
