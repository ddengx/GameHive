//
//  Item.swift
//  GameHive
//
//  Created by Darren Deng on 3/20/25.
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
