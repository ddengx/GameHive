//
//  Game.swift
//  GameHive
//
//  Created by Darren Deng on 3/28/25.
//

import Foundation
import SwiftData

@Model
final class Game: Identifiable {
    var id: Int
    var title: String
    var image: String

    init(id: Int, title: String, image: String) {
        self.id = id
        self.title = title
        self.image = image
    }
}
