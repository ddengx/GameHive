//
//  RawgGame.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//

import Foundation

// Model representing a response from the /games endpoint of RawgAPI
struct RawgResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RawgGame]
}

// A model representation of a game object fro RawgAPI
struct RawgGame: Identifiable, Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount: Int?
    let metacritic: Int?
    let parentPlatforms: [PlatformParent]?
    let genres: [Genre]?
    let tags: [Tag]?
    
    // Since RawgAPI's names are in kebab case, convert to camel
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, metacritic, genres, tags
        case backgroundImage = "background_image"
        case ratingsCount = "ratings_count"
        case parentPlatforms = "parent_platforms"
    }
}

//-------------------------------------------------------------
// Below are a collection of structs representing nested objects in RawgGame and RawgGameDetail models

struct Genre: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Tag: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String
    let language: String
}

struct PlatformParent: Identifiable, Codable {
    let platform: Platform
    
    var id: Int {
        return platform.id
    }
}

struct Platform: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Developer: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int?
    let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

struct EsrbRating: Identifiable, Codable {
    let id: Int
    let slug: String
    let name: String
}
