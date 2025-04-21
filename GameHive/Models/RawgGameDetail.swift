//
//  RawgGameDetail.swift
//  GameHive
//
//  Created by Darren Deng on 4/20/25.
//

import Foundation

// For the /games/{id} endpoint (details and search) of RawgAPI
// Abstracted away from RawgGame because the response is different

struct RawgGameDetail: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let metacritic: Int?
    let description: String
    let parentPlatforms: [PlatformParent]?
    let genres: [Genre]?
    let developers: [Developer]?
    let esrbRating: EsrbRating?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, metacritic, genres, developers
        case backgroundImage = "background_image"
        case description = "description_raw"
        case parentPlatforms = "parent_platforms"
        case esrbRating = "esrb_rating"
    }
}
//-------------------------------------------------------------
