//
//  FavoriteGame.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//
//  This is the model for a Favorite Game
//  It represents the persistent storage of a RawgGame

import Foundation
import SwiftData

@Model
final class FavoriteGame: Identifiable {
    var gameId: Int
    var title: String
    var imageUrl: String?
    var rating: Double
    
    init(gameId: Int, title: String, imageUrl: String? = nil, rating: Double = 0.0) {
        self.gameId = gameId
        self.title = title
        self.imageUrl = imageUrl
        self.rating = rating
    }
}

// Function to convert a FavoriteGame to RawgGame
// A really hacky-ish method to create navigation links to a GameDetailView
// Work around was caused by scattered end points from RawgAPI
extension FavoriteGame {
    func toRawgGame() -> RawgGame {
        return RawgGame(
            id: self.gameId,
            name: self.title,
            released: nil,
            backgroundImage: self.imageUrl,
            rating: self.rating,
            ratingsCount: nil,
            metacritic: nil,
            parentPlatforms: nil,
            genres: nil,
            tags: nil
        )
    }
}
